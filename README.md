fds:pronouncing
===========

A Meteor package that provides a pronouncing dictionary of English.


Installation
------------

Install by running;

```ShellSession
$ meteor add fds:pronouncing
```

within a [Meteor](https://www.meteor.com/) project.


Usage
-----

The package exports a single collection called `Pronunciations`. The first time
a Meteor project is run after Pronouncing has been installed, the package will
automatically initialize the `Pronunciations` collection (this takes a while).
If you run `meteor reset`, the collection will automatically re-initialize.


Acknowledgments
---------------

Susan Bartlett, [Grzegorz Kondrak](http://webdocs.cs.ualberta.ca/~kondrak/)
and Colin Cherry.
[On the Syllabification of Phonemes](http://webdocs.cs.ualberta.ca/~kondrak/papers/naacl09.pdf).
NAACL-HLT 2009.
