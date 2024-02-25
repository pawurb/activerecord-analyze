# frozen_string_literal: true

require "rubygems"
require "active_record/railtie"
require "bundler/setup"
require "migrations/create_users_migration.rb"
require_relative "../lib/activerecord-analyze"

ENV["DATABASE_URL"] ||= "postgresql://postgres:secret@localhost:5432/activerecord-analyze-test"

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection(
      ENV.fetch("DATABASE_URL")
    )

    ActiveRecord::Schema.define do
      unless ActiveRecord::Base.connection.table_exists? "users"
        CreateUsers.new.change
      end
    end
  end
end
