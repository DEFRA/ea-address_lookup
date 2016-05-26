# EA::AddressLookup

[![Build Status](https://travis-ci.org/EnvironmentAgency/ea-address_lookup.svg?branch=master)](https://travis-ci.org/EnvironmentAgency/ea-address_lookup)
[![Code Climate](https://codeclimate.com/github/EnvironmentAgency/ea-address_lookup/badges/gpa.svg)](https://codeclimate.com/github/EnvironmentAgency/ea-address_lookup)
[![Test Coverage](https://codeclimate.com/github/EnvironmentAgency/ea-address_lookup/badges/coverage.svg)](https://codeclimate.com/github/EnvironmentAgency/ea-address_lookup/coverage)

This ruby gem provides address lookup functionality by postcode.

## Installation

Add the gem to your Gemfile

```ruby
gem "ea-address_lookup"
```

Then execute:

```bash
bundle install
```

You may also need to add this to your ruby code before using this gem:

```ruby
require "ea/address_lookup"
```

## Usage

### Rails

Create an intializer eg `config/initializers/address_lookup.rb`

```ruby
EA::AddressLookup.configure do |config|
  config.address_facade_server = <some_host_name>
  config.address_facade_port = ""
  config.address_facade_url = "/address-service/v1/addresses/""
  config.address_facade_client_id = <client_id>
  config.address_facade_key = <key>
end
```

Now you can do the following:

```ruby
EA::AddressLookup.adapter = :address_facade # optional as its the default
hash = EA::AddressLookup.find_by_postcode('BA1 5AH')
hash = EA::AddressLookup.find_by_uprn('12345678')
```

## Testing with RSpec
A test helper is included that provides methods that will stub calls to
EA::AddressLookup methods in RSpec tests. To enable them add this to
the rspec configuration (for example, within a `RSpec.configure do |config|`
block in a Rails app's `spec/rails_helper.rb`):

```ruby
config.include EA::AddressLookup::TestHelper::RspecMocks
```

This will make the methods defined in `lib/ea/address_lookup/test_helper/rspec_mocks.rb`
available within the host app's rspec tests. For example:

```ruby
describe "postcode lookup" do
  before do
    mock_ea_address_lookup_find_by_postcode
  end

  it "some tests that use data returned by a postcode lookup" do
    ....
  end
end
```


## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3

The following attribution statement MUST be cited in your products and applications when using this information.

>Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
