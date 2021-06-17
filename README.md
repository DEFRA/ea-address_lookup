# EA::AddressLookup

[![Build Status](https://travis-ci.com/DEFRA/ea-address_lookup.svg?branch=main)](https://travis-ci.com/DEFRA/ea-address_lookup)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_ea-address_lookup&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=DEFRA_ea-address_lookup)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=DEFRA_ea-address_lookup&metric=coverage)](https://sonarcloud.io/dashboard?id=DEFRA_ea-address_lookup)
[![security](https://hakiri.io/github/DEFRA/ea-address_lookup/main.svg)](https://hakiri.io/github/DEFRA/ea-address_lookup/main)
[![Gem Version](https://badge.fury.io/rb/ea-address_lookup.svg)](https://badge.fury.io/rb/ea-address_lookup)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

> This repo is no longer being maintained or used. For an address lookup gem that can integrate with the EA Address Facade or the OS Places Address Lookup, use [DefraRuby::Address](https://github.com/DEFRA/defra-ruby-address)

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
  config.address_facade_url = "/address-service/v1/addresses/"
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
EA::AddressLookup methods in RSpec tests.

The available mock methods are:

```ruby
mock_ea_address_lookup_find_by_uprn
mock_failure_of_ea_address_lookup_find_by_uprn
mock_ea_address_lookup_find_by_postcode
mock_failure_of_ea_address_lookup_find_by_postcode
```

To enable them add this to the rspec configuration (for example, within a
 `RSpec.configure do |config|` block in a Rails app's `spec/rails_helper.rb`):

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
    # Any EA::AddressLookup.find_by_postcode calls made in this spec will return the same
    # mocked data, and no external requests will be made, so you don't need webmock/VCR.
    # You can pass any postcode or uprn argument to the find_by_* methods, but they will
    # always return the mocked data and will not echo back your input.
    # See test_helper/address_lookup.yml to examine the mock data that will be returned.
  end
end
```

Note, that you can also pass output modifications into the mock methods:

```ruby
describe "postcode lookup" do
  let(:address_one) do
    {
      "uprn" => 340116
        ....
      "source_data_type" => dpa
    }
  end
  let(:address_two) { address_one.merge("postcode" => "XX7 8XX" }
  let(:addresses) { [address_one, address_two] }

  before do
    mock_ea_address_lookup_find_by_postcode("results" => addresses)
  end

  it "some tests that use data returned by a postcode lookup" do
    address_data = EA::AddressLookup.find_by_uprn("77138")
    expect(address_data["results"]).to eq(addresses)
  end
end
```

The modifications are merged into the output, so must match the correct data
structure. Note that in the example above `address_data["results"]` returns
an array of address data hashes.

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

<http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3>

The following attribution statement MUST be cited in your products and applications when using this information.

>Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
