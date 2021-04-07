module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module DatabaseStatements
        def analyze(arel, binds = [], opts = {})
          format_sql = if fmt = opts[:format].presence
            case fmt
            when :json
              "FORMAT JSON,"
            when :hash
              "FORMAT JSON,"
            when :yaml
              "FORMAT YAML,"
            when :text
              "FORMAT TEXT,"
            when :xml
              "FORMAT XML,"
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

          opts_sql = "(#{format_sql} #{analyze_sql}#{verbose_sql}#{costs_sql}#{settings_sql}#{buffers_sql}#{timing_sql}#{summary_sql})"
          .strip.gsub(/\s+/, " ")
          .gsub(/\(\s?\s?\s?,/, "(")
          .gsub(/\s,\s/, " ")
          .gsub(/\(\s?\)/, "")

          sql = "EXPLAIN #{opts_sql} #{to_sql(arel, binds)}"
          PostgreSQL::ExplainPrettyPrinter.new.pp(exec_query(sql, "EXPLAIN #{opts_sql}".strip, binds))
        end
      end
    end
  end
end

module ActiveRecord
  class Relation
    def analyze(opts = {})
      res = exec_analyze(collecting_queries_for_explain { exec_queries }, opts)
      if [:json, :hash].include?(opts[:format])
        start = res.index("[")
        finish = res.rindex("]")
        raw_json = res.slice(start, finish - start + 1)

        if opts[:format] == :json
          JSON.parse(raw_json).to_json
        elsif opts[:format] == :hash
          JSON.parse(raw_json)
        end
      else
        res
      end
    end
  end
end

module ActiveRecord
  module Explain
    def exec_analyze(queries, opts = {}) # :nodoc:
      str = queries.map do |sql, binds|
        analyze_msg = if opts[:analyze] == false
          ""
        else
          " ANALYZE"
        end

        msg = "EXPLAIN#{analyze_msg} for: #{sql}".dup
        unless binds.empty?
          msg << " "
          msg << binds.map { |attr| render_bind(attr) }.inspect
        end
        msg << "\n"
        msg << connection.analyze(sql, binds, opts)
      end.join("\n")

      # Overriding inspect to be more human readable, especially in the console.
      def str.inspect
        self
      end

      str
    end
  end
end

