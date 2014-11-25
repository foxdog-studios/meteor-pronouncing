'use strict';

Package.describe({
  summary: 'Provides a pronouncing dictionary of English',
  name: 'fds:pronouncing',
  version: '1.0.0',
  git: 'https://github.com/foxdog-studios/meteor-pronouncing'
});

Package.onUse(function (api) {
  api.versionsFrom('1.0');
  api.use('coffeescript');
  api.use('underscore', 'server');
  api.addFiles(['pronunciations.json', 'server.coffee'], 'server');
  api.addFiles('shared.coffee');
});

Package.onTest(function (api) {
  api.use(['coffeescript', 'fds:pronouncing', 'tinytest']);
  api.addFiles('tests.coffee');
});

