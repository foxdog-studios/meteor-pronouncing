Pronouncing
===========

A Meteor smart package that provides a pronouncing dictionary of English.


Installation
------------

Install via [Atmosphere](https://atmospherejs.com/package/pronouncing) using
[Meteorite](https://github.com/oortcloud/meteorite/#installing-meteorite) by
running;

```Shell
$ mrt add pronouncing
```

within your [Meteor](https://www.meteor.com/) project.


Usage
-----

The package exports a single collection called `Pronunciations`. The first time
a Meteor project is run after Pronouncing has been install, the package will
automatically initialize the `Pronunciations` collection (this takes a while).
If you run `meteor reset`, the collection will automatically re-initialize.


Acknowledgments
---------------

Susan Bartlett, [Grzegorz Kondrak](http://webdocs.cs.ualberta.ca/~kondrak/)
and Colin Cherry.
[On the Syllabification of Phonemes](http://webdocs.cs.ualberta.ca/~kondrak/papers/naacl09.pdf).
NAACL-HLT 2009.
