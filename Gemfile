source 'https://rubygems.org'
ruby "2.2.3"

# Specify your gem's dependencies in whereabouts.gemspec
gemspec

# Use the test group rather than putting gems for testing in the gemspec with
# add_development_dependency
group :test do
  gem "vcr", "~> 3.0"
  gem "webmock", "~> 1.24"
  gem "shoulda-matchers", "~> 3.1", require: false
  gem 'simplecov', require: false # Tool for checking code coverage
  gem "byebug"
  gem "awesome_print", require: false # Pretty pring output e.g. 'ap thing' - require 'ap' first
end
