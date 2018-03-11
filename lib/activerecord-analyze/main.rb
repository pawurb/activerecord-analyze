module ActiveRecord
  module ConnectionAdapters
    module PostgreSQL
      module DatabaseStatements
        def analyze(arel, binds = [])
          sql = "EXPLAIN ANALYZE #{to_sql(arel, binds)}"
          PostgreSQL::ExplainPrettyPrinter.new.pp(exec_query(sql, "EXPLAIN ANALYZE", binds))
        end
      end
    end
  end
end

module ActiveRecord
  class Relation
    def analyze
      exec_analyze(collecting_queries_for_explain { exec_queries })
    end
  end
end

module ActiveRecord
  module Explain
    def exec_analyze(queries) # :nodoc:
      str = queries.map do |sql, binds|
        msg = "EXPLAIN ANALYZE for: #{sql}".dup
        unless binds.empty?
          msg << " "
          msg << binds.map { |attr| render_bind(attr) }.inspect
        end
        msg << "\n"
        msg << connection.analyze(sql, binds)
      end.join("\n")

      # Overriding inspect to be more human readable, especially in the console.
      def str.inspect
        self
      end

      str
    end
  end
end

