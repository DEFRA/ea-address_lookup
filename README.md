# EA::AddressLookup

This ruby gem provides address lookup functionality by postcode.

## Installation

Add the gem to your Gemfile

```ruby
gem 'ea-address_lookup'
```

Then execute:

```bash
bundle install
```

## Usage

### Rails

Create an intializer eg ```config/initializers/address_lookup.rb```

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
