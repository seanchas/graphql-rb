require 'graphql/configuration/slot'

RSpec.describe GraphQL::Configuration::Slot do

  SlotClass = GraphQL::Configuration::Slot

  it "Should build slot" do
    expect {
      SlotClass.new do
        name          'Test'
        type          [String]
        coerce        -> (value) { value.to_s }
        description   'ABC'
      end
    }.not_to raise_error
  end

end
