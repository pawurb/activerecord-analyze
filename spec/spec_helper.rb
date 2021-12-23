# frozen_string_literal: true

require 'rubygems'
require "active_record/railtie"
require 'bundler/setup'
require "migrations/create_users_migration.rb"
require_relative '../lib/activerecord-analyze'

ENV["DATABASE_URL"] ||= "postgresql://postgres:secret@localhost:5432/activerecord-analyze-test"

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(
      ENV.fetch("DATABASE_URL")
    )

    @schema_migration = ActiveRecord::Base.connection.schema_migration
    ActiveRecord::Migrator.new(:up, [CreateUsers.new], @schema_migration).migrate
  end
end
