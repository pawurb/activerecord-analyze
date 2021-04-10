# ActiveRecord Analyze [![Gem Version](https://badge.fury.io/rb/activerecord-analyze.svg)](https://badge.fury.io/rb/activerecord-analyze) [![CircleCI](https://circleci.com/gh/pawurb/activerecord-analyze.svg?style=svg)](https://circleci.com/gh/pawurb/activerecord-analyze)

This gem adds an `analyze` method to Active Record query objects. It executes `EXPLAIN ANALYZE` on a query SQL.

You can check out this blog post for more info on how to [debug and fix slow queries in Rails apps](https://pawelurbanek.com/slow-rails-queries).

The following `format` options are supported `:json, :hash, :yaml, :text, :xml`. Especially the `:json` format is useful because it let's you visualize a query plan using [a visualizer tool](https://tatiyants.com/pev/#/plans/new).

![PG Query visualizer plan](https://raw.githubusercontent.com/pawurb/activerecord-analyze/master/query-plan.png)

## Installation

In your Gemfile:

```ruby

gem 'activerecord-analyze'

```

## Options

The `analyze` method supports the following EXPLAIN query options ([PostgreSQL docs reference](https://www.postgresql.org/docs/12/sql-explain.html)):

```
BUFFERS [ boolean ]
VERBOSE [ boolean ]
COSTS [ boolean ]
SETTINGS [ boolean ]
TIMING [ boolean ]
SUMMARY [ boolean ]
FORMAT { TEXT | XML | JSON | YAML }
```

You can execute it like that:

```ruby

puts User.all.analyze(
  format: :pretty, # :pretty format option generates a formatted JSON output
  verbose: true,
  costs: true,
  settings: true,
  buffers: true,
  timing: true,
  summary: true
)

# EXPLAIN (FORMAT JSON, ANALYZE, VERBOSE, COSTS, SETTINGS, BUFFERS, TIMING, SUMMARY)
# SELECT "users".* FROM "users"
# [
#   {
#     "Plan": {
#       "Node Type": "Seq Scan",
#       "Parallel Aware": false,
#       "Relation Name": "users",
#       "Schema": "public",
#       "Alias": "users",
#       "Startup Cost": 0.00,
#       "Total Cost": 11.56,
#       "Plan Rows": 520,
#       "Plan Width": 127,
#       "Actual Startup Time": 0.006,
#       "Actual Total Time": 0.007,
#       "Actual Rows": 2,
#       "Actual Loops": 1,
#       "Output": ["id", "team_id", "email"],
#       "Shared Hit Blocks": 1,
#       "Shared Read Blocks": 0,
#       "Shared Dirtied Blocks": 0,
#       "Shared Written Blocks": 0,
#       "Local Hit Blocks": 0,
#       "Local Read Blocks": 0,
#       "Local Dirtied Blocks": 0,
#       "Local Written Blocks": 0,
#       "Temp Read Blocks": 0,
#       "Temp Written Blocks": 0,
#       "I/O Read Time": 0.000,
#       "I/O Write Time": 0.000
#     },
#     "Settings": {
#       "cpu_index_tuple_cost": "0.001",
#       "cpu_operator_cost": "0.0005",
#       "cpu_tuple_cost": "0.003",
#       "effective_cache_size": "10800000kB",
#       "max_parallel_workers_per_gather": "1",
#       "random_page_cost": "2",
#       "work_mem": "100MB"
#     },
#     "Planning Time": 0.033,
#     "Triggers": [
#     ],
#     "Execution Time": 0.018
#   }
# ]

```

Optionally you can disable running the `ANALYZE` query and only generate the plan:

```ruby

User.all.analyze(analyze: false)

# EXPLAIN ANALYZE for: SELECT "users".* FROM "users"
#                         QUERY PLAN
# ----------------------------------------------------------
#  Seq Scan on users  (cost=0.00..15.20 rows=520 width=127)

```

### Disclaimer

It is a bit experimental and can break with new Rails release.
