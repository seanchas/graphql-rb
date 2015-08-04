require 'graphql/configuration/slots'

RSpec.describe GraphQL::Configuration::Slots do

  SlotClass   = GraphQL::Configuration::Slot
  SlotsClass  = GraphQL::Configuration::Slots

  it "Should build slot" do
    expect {
      SlotClass.new do
        name          'Test'
        type          String
        coerce        -> (value) { value.to_s }
        description   'ABC'
      end
    }.not_to raise_error
  end

  it "Should build slots" do
    slots = SlotsClass.new do
      slot :name, String, coerce: -> (value) { value.to_s }
    end

    slots.name = :abc
    puts slots.name.inspect
  end

end
