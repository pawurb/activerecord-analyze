# frozen_string_literal: true

require 'spec_helper'
require "migrations/create_users_migration.rb"

class User < ActiveRecord::Base; end

describe "ActiveRecord analyze" do
  before(:all) do
    ActiveRecord::Base.establish_connection(
      ENV.fetch("DATABASE_URL")
    )

    @schema_migration = ActiveRecord::Base.connection.schema_migration
    ActiveRecord::Migrator.new(:up, [CreateUsers.new], @schema_migration).migrate
  end

  describe "no opts" do
    it "works" do
      expect do
        User.all.analyze
      end.not_to raise_error
    end
  end

  describe "format json" do
    it "works" do
      result = User.all.analyze(format: :json)
      expect(JSON.parse(result)[0].keys.sort).to eq [
        "Execution Time", "Plan", "Planning Time", "Triggers"
      ]
    end
  end
end
