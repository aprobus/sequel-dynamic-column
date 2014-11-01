require 'bundler/setup'
Bundler.require :default, :test

require_relative '../lib/json_wide_row'

Sequel.extension :migration
DB = Sequel.connect('postgres://localhost/json_wide_row_test', max_connections: 2)
DB.extension(:pg_array, :pg_json)

Sequel::Migrator.run(DB, "spec/migrations")
Sequel::Model.db = DB

require_relative 'data/spice_data'

RSpec.configure do |config|
  config.order = 'random'

  config.before(:suite) do
    DatabaseCleaner[:sequel, { :connection => DB }]
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

