# frozen_string_literal: true

require "activerecord-analyze/main"

module ActiveRecordAnalyze
  def self.analyze_sql(raw_sql, opts = {})
    if opts[:full_debug] == true
      opts = {
        format: :pretty_json,
        verbose: true,
        costs: true,
        buffers: true,
        timing: true,
        summary: true,
      }
    end

    prefix = "EXPLAIN #{build_prefix(opts)}"

    result = ActiveRecord::Base.connection.execute("#{prefix} #{raw_sql}").to_a

    if [:json, :hash, :pretty_json].include?(opts[:format])
      raw_json = result[0].fetch("QUERY PLAN")
      if opts[:format] == :json
        raw_json
      elsif opts[:format] == :hash
        JSON.parse(raw_json)
      elsif opts[:format] == :pretty_json
        JSON.pretty_generate(JSON.parse(raw_json))
      end
    else
      result.map do |el|
        el.fetch("QUERY PLAN")
      end.join("\n")
    end
  end

  def self.build_prefix(opts = {})
    format_sql = if fmt = opts[:format].presence
        case fmt
        when :json
          "FORMAT JSON, "
        when :hash
          "FORMAT JSON, "
        when :pretty_json
          "FORMAT JSON, "
        when :yaml
          "FORMAT YAML, "
        when :text
          "FORMAT TEXT, "
        when :xml
          "FORMAT XML, "
        else
          ""
        end
      end

    verbose_sql = if opts[:verbose] == true
        ", VERBOSE"
      end

    costs_sql = if opts[:costs] == true
        ", COSTS"
      end

    settings_sql = if opts[:settings] == true
        ", SETTINGS"
      end

    buffers_sql = if opts[:buffers] == true
        ", BUFFERS"
      end

    timing_sql = if opts[:timing] == true
        ", TIMING"
      end

    summary_sql = if opts[:summary] == true
        ", SUMMARY"
      end

    analyze_sql = if opts[:analyze] == false
        ""
      else
        "ANALYZE"
      end

    opts_sql = "(#{format_sql}#{analyze_sql}#{verbose_sql}#{costs_sql}#{settings_sql}#{buffers_sql}#{timing_sql}#{summary_sql})"
      .strip.gsub(/\s+/, " ")
      .gsub(/\(\s?\s?\s?,/, "(")
      .gsub(/\s,\s/, " ")
      .gsub(/\(\s?\)/, "")
      .gsub(/,\s+\)/, ")")
  end
end
