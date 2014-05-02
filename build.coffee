#!/usr/bin/env coffee

fs   = require 'fs'
http = require 'http'
path = require 'path'

PRONUNCIATIONS_INPUT = path.resolve __dirname, 'pronunciations.txt'
PRONUNCIATIONS_OUTPUT = path.resolve __dirname, 'pronunciations.json'

PRONUNCIATIONS_URL = \
    'http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/cmudict.0.7a'

createFixtures = (data) ->
  fixtures = []
  for line in data.split '\n'
    if (fixture = tryRenderFixture line)?
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
  return if line.length == 0 or /^;;;/.test line
  [id, parts...] = line.split /\s+/
  idMatch = id.match /^([^A-Z]+)?(['\-.0-9A-Z_]+)(?:\((\d+)\))?$/
  error = ->
    throw "Invalid entry: #{ line }"
  if not idMatch? or parts.length == 0
    error()
  pronunciation = for part in parts
    partMatch = part.match /^([A-Z]+)([0-2])?$/
    error() unless partMatch?
    phoneme: partMatch[1]
    stress: parseInt partMatch[2] ? 0
  _id: id
  apperance: (idMatch[1] ? idMatch[2]).replace '_', ' '
  name: idMatch[2]
  variant: parseInt idMatch[3] ? 0
  pronunciation: pronunciation

main = ->
  downloadIfRequireThenReadPronunciations (err, data) ->
    throw err if err?
    fixtures = JSON.stringify createFixtures(data)
    fs.writeFile PRONUNCIATIONS_OUTPUT, fixtures, (err) ->
      throw err if err?

main()

