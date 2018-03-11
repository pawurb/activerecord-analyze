# ActiveRecord Analyze

This gem adds an `analyze` method to Active Record query objects. It executes `EXPLAIN ANALYZE` on a query SQL.

![alt text](https://pawelurbanek.com/files/active-record-analyze.png)

## Installation

In your Gemfile:

```ruby

gem 'activerecord-analyze'

```

### Disclaimer

It is a bit experimental and can break with new Rails release. As soon as [this pull request](https://github.com/rails/rails/pull/31374/) is merged it will be obsolete.
