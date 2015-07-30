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
    expect { create_value(name: 'A', value: 1, description: 1) }.to raise_error('Invalid')
    expect { create_value(name: 'A', value: 1, deprecation_reason: 1) }.to raise_error('Invalid')
  end


  def create_type(*args, &block)
    GraphQL::GraphQLEnum.new(*args, &block)
  end


  it "Should create enum type" do
    expect {
      create_type do
        name          'A'
        description   'B'
        values({
          'A' => GraphQL::GraphQLEnumValue.new(name: 'A'),
          'B' => GraphQL::GraphQLEnumValue.new(name: 'B', value: 2)
        })
      end
    }.not_to raise_error

    expect {
      create_type do
        name          'A'
        description   'B'
        value         'A'
        value         'B', 2
      end
    }.not_to raise_error
  end

  it "Should not create enum type" do
    expect {
      create_type
    }.to raise_error('Invalid')

    expect {
      create_type do
        name 'A'
      end
    }.to raise_error('Invalid')

    expect {
      create_type do
        name 'A'
        value 123
      end
    }.to raise_error('Invalid')
  end

end
