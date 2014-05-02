Meteor.startup ->
  if Pronunciations.find().count() == 0
    console.log 'Initializing Pronunciations collection
                 (this may take a while) ...'
    pronunciations = JSON.parse Assets.getText 'pronunciations.json'
    total = pronunciations.length
    next = 0
    for pronunciation, i in pronunciations
      if i >= next
        console.log "#{ (i * 100 / total).toFixed 0 }%  ..."
        next += 0.1 * total
      Pronunciations.insert pronunciation
    console.log 'Pronunciations collection initialized.'

