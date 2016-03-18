# require 'spec_helper'

# describe Whereabouts::Adapters do
#   describe "#adapter" do
#     it "defaults to :address_facade" do
#       expect(described_class.adapter).to eq(Whereabouts::Adapters::AddressFacade)
#     end
#   end

#   describe "#adpater=" do
#     it "assigns a matching adapter class" do
#       Whereabouts::Adapters.const_set(:TestAdapter, Module.new)
#       described_class.adapter = :test_adapter
#       expect(described_class.adapter).to eq(Whereabouts::Adapters::TestAdapter)
#     end

#     it "raises an error nil passed" do
#       expect{ described_class.adapter = nil}.to raise_error(Whereabouts::MissingAdapterError)
#     end

#     it "raises an error if the adapter is not found" do
#       expect{ described_class.adapter = :yay_mama}
#         .to raise_error(Whereabouts::UnrecognisedAdapterError)
#     end
#   end
# end
