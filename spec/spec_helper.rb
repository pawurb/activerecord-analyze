# frozen_string_literal: true

require 'rubygems'
require "active_record/railtie"
require 'bundler/setup'
require_relative '../lib/activerecord-analyze'

ENV["DATABASE_URL"] ||= "postgresql://postgres:secret@localhost:5432/activerecord-analyze-test"
