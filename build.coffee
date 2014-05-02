#!/usr/bin/env coffee

fs   = require 'fs'
http = require 'http'
path = require 'path'

PRONUNCIATIONS_INPUT = path.resolve __dirname, 'pronunciations.txt'
PRONUNCIATIONS_OUTPUT = path.resolve __dirname, 'pronunciations.json'

PRONUNCIATIONS_URL = \
  'http://webdocs.cs.ualberta.ca/~kondrak/cmudict/cmudict.rep'

createFixtures = (data) ->
  ids = {}
  fixtures = []
  for line in data.split '\n'
    fixture = tryRenderFixture line
    if fixture? and not ids.hasOwnProperty fixture._id
      ids[fixture._id] = null
      fixtures.push fixture
  fixtures

downloadPronunciations = (callback) ->
  file = fs.createWriteStream PRONUNCIATIONS_INPUT
  http.get PRONUNCIATIONS_URL, (response) ->
    response.pipe file
    file.on 'finish', ->
      file.close callback
    file.on 'error', (err) ->
      fs.unlink PRONUNCIATIONS_URL
      callback err

downloadIfRequireThenReadPronunciations = (callback) ->
  readPronunciations (err, data) ->
    if err?.errno == 34
      downloadThenReadPronunciations callback
    else
      callback err, data

downloadThenReadPronunciations = (callback) ->
  downloadPronunciations (err) ->
    if err?
      callback err
    else
      readPronunciations callback

readPronunciations = (callback) ->
  fs.readFile PRONUNCIATIONS_INPUT, { encoding: 'ascii' }, callback

tryRenderFixture = (line) ->
  # Skip empty lines and comments
  if line.length == 0 or /^##/.test line
    return

  # The info and syllables are separated by whitespace.
  [rawInfo, rawPronunciation...] = line.split /\s+/

  #
  # Parse pronunciation
  #

  # Syllables are separated a dash.
  rawSyllables = []
  rawSyllable = []
  for token in rawPronunciation
    if token == '-'
      rawSyllables.push rawSyllable
      rawSyllable = []
    else
      rawSyllable.push token
  rawSyllables.push rawSyllable

  syllables =
    for rawSyllable in rawSyllables
      for rawPhoneme in rawSyllable
        # A phoneme may have an optional stress.
        match = rawPhoneme.match /^([A-Z]+)([0-2])?$/
        phoneme = phoneme: match[1]
        phoneme.stress = parseInt match[2] if match[2]?
        phoneme

  # Parse info to appearance (optional), name, and variation (optional).
  match = rawInfo.match /^([^A-Z]+)?(['\-.0-9A-Z_]+)(?:\((\d+)\))?$/

  pronunciation =
    # rawInfo provides a consistent ID, allowing the collection to be
    # rebuild.
    _id: rawInfo

    # Spaces are represented with underscores.
    appearance: (match[1] ? match[2]).replace '_', ' '

    name: match[2]
    syllables: syllables

  pronunciation.variant = parseInt match[3] if match[3]?

  pronunciation

main = ->
  downloadIfRequireThenReadPronunciations (err, data) ->
    throw err if err?
    fixtures = JSON.stringify createFixtures(data)
    fs.writeFile PRONUNCIATIONS_OUTPUT, fixtures, (err) ->
      throw err if err?

main()

