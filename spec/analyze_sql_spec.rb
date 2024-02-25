# frozen_string_literal: true

require "spec_helper"

describe "ActiveRecord analyze" do
  let(:raw_sql) do
    "SELECT * FROM users WHERE email = 'email@example.com'"
  end

  let(:result) do
    ActiveRecordAnalyze.analyze_sql(raw_sql, opts)
  end

  describe "default opts" do
    let(:opts) do
      {}
    end

    it "works" do
      expect do
        result
      end.not_to raise_error
    end
  end

  describe "format json" do
    let(:opts) do
      { format: :json }
    end

    it "works" do
      puts result
      expect(JSON.parse(result)[0].keys.sort).to eq [
           "Execution Time", "Plan", "Planning Time", "Triggers",
         ]
    end
  end

  describe "format hash" do
    let(:opts) do
      { format: :hash }
    end

    it "works" do
      expect(result[0].keys.sort).to eq [
           "Execution Time", "Plan", "Planning Time", "Triggers",
         ]
    end
  end

  describe "format pretty" do
    let(:opts) do
      { format: :pretty_json }
    end

    it "works" do
      expect(JSON.parse(result)[0].keys.sort).to eq [
           "Execution Time", "Plan", "Planning Time", "Triggers",
         ]
    end
  end

  describe "supports options" do
    let(:raw_sql) do
      "SELECT \"users\".* FROM \"users\" WHERE \"users\".\"email\" IS NOT NULL LIMIT 10"
    end

    let(:opts) do
      {
        format: :hash,
        costs: true,
        timing: true,
        summary: true,
      }
    end

    it "works" do
      expect(result[0].keys.sort).to eq [
           "Execution Time", "Plan", "Planning Time", "Triggers",
         ]
    end
  end

  describe "supports full_debug option" do
    let(:raw_sql) do
      "SELECT \"users\".* FROM \"users\" WHERE \"users\".\"email\" IS NOT NULL LIMIT 10"
    end

    let(:opts) do
      {
        full_debug: true,
      }
    end

    it "works" do
      puts result
      expect(JSON.parse(result)[0].keys.sort).to eq [
           "Execution Time", "Plan", "Planning Time", "Triggers",
         ]
    end
  end
end
