Tinytest.add 'Pronouncing - Collection exists', (test) ->
  test.instanceOf(
    Pronunciations,
    Meteor.Collection,
    'Expected Pronunciations to be a collection'
  )

if Meteor.isServer
  Tinytest.add 'Pronouncing - Count', (test) ->
    count = Pronunciations.find().count()
    expected = 133334
    test.equal count, expected, "Expected #{ expected } pronunciations"

