require 'graphql'

RSpec.describe GraphQL::GraphQLEnum do

  def create_value(attributes = {})
    GraphQL::GraphQLEnumValue.new(attributes)
  end


  it 'Should create enum value' do
    expect { create_value(name: 'A', value: nil) }.not_to raise_error
    expect { create_value(name: 'A', value: 1, description: 'B') }.not_to raise_error
    expect { create_value(name: 'A', value: 1, description: 'B', deprecation_reason: 'C') }.not_to raise_error
  end

  it 'Should not create enum value' do
    expect { create_value }.to raise_error('Invalid')
    expect { create_value(name: 1) }.to raise_error('Invalid')
    expect { create_value(name: 'A') }.to raise_error('Invalid')
    expect { create_value(name: 'A', value: 1, description: 1) }.to raise_error('Invalid')
    expect { create_value(name: 'A', value: 1, deprecation_reason: 1) }.to raise_error('Invalid')
  end

end
