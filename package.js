Package.describe({
  summary: 'Provides a pronouncing dictionary of English'
});

Package.on_use(function (api, where) {
  api.use(['coffeescript'], ['client', 'server']);
  api.use(['underscore'], ['server']);
  api.add_files(['pronunciations.json', 'server.coffee'], ['server']);
  api.add_files(['shared.coffee'], ['client', 'server']);
});

Package.on_test(function (api) {
  api.use(['coffeescript', 'pronouncing', 'tinytest']);
  api.add_files('tests.coffee', ['client', 'server']);
});

