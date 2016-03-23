SimpleCov.start "rails" do
  # any custom configs like groups and filters can be here at a central place

  # The enrollment builder controller is just used to create dummy records when
  # working in development as a time saver. We are happy there is no test coverage
  # for it.
  add_filter "lib/ea/address_lookup/version.rb"
  add_filter "lib/ea/address_lookup/adapters/locate_api.rb" # demo class
end
