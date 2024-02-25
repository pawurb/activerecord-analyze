module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module DatabaseStatements
        def analyze(arel, binds = [], opts = {})
          opts_sql = ActiveRecordAnalyze.build_prefix(opts)

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

      res = exec_analyze(collecting_queries_for_explain { exec_queries }, opts)
      if [:json, :hash, :pretty_json].include?(opts[:format])
        start = res.index("[\n")
        finish = res.rindex("]")
        raw_json = res.slice(start, finish - start + 1)

        if opts[:format] == :json
          JSON.parse(raw_json).to_json
        elsif opts[:format] == :hash
          JSON.parse(raw_json)
        elsif opts[:format] == :pretty_json
          JSON.pretty_generate(JSON.parse(raw_json))
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
