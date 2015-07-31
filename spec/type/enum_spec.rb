require 'graphql'

RSpec.describe GraphQL::GraphQLEnum do

  def create_value(attributes = {})
    GraphQL::GraphQLEnumValue.new(attributes)
  end


  def create_rgba_enum_full
    GraphQL::GraphQLEnum.new do
      name  'RGBA'

      values({
        'RED'   => GraphQL::GraphQLEnumValue.new(name: 'RED',   value: 0),
        'GREEN' => GraphQL::GraphQLEnumValue.new(name: 'GREEN', value: 1),
        'BLUE'  => GraphQL::GraphQLEnumValue.new(name: 'BLUE',  value: 2),
        'ALPHA' => GraphQL::GraphQLEnumValue.new(name: 'ALPHA', value: 3, deprecation_reason: 'Just kidding')
      })
    end
  end

  def create_rgba_enum_short
    GraphQL::GraphQLEnum.new do
      name 'RGBA'

      value :RED,     0
      value :GREEN,   1
      value :BLUE,    2
      value :ALPHA,   3, deprecation_reason: 'Just kidding'
    end
  end


  it 'Should create enum value' do
    expect { create_value(name: 'A', value: nil) }.not_to raise_error
    expect { create_value(name: 'A', value: 1, description: 'B') }.not_to raise_error
    expect { create_value(name: 'A', value: 1, description: 'B', deprecation_reason: 'C') }.not_to raise_error
    expect { create_rgba_enum_full }.not_to raise_error
    expect { create_rgba_enum_short }.not_to raise_error
  end

  it 'Should set attributed on enum value' do
    value = create_value(name: 'A', value: 5)
    value.name  = 'B'
    value.value = 1
    expect(value.name).to eql('B')
    expect(value.value).to eql(1)
    value.name = :B
    expect(value.valid?).to eql(false)
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
      type = create_type do
        name          'A'
        description   'B'
        values({
          'A' => GraphQL::GraphQLEnumValue.new(name: 'A'),
          'B' => GraphQL::GraphQLEnumValue.new(name: 'B', value: 2)
        })
      end

      expect(type.values.keys.sort).to eql(['A', 'B'])
    }.not_to raise_error

    expect {
      type = create_type do
        name          'A'
        description   'B'
        value         'A'
        value         'B', 2
      end

      expect(type.coerce(2)).to eql('B')
      expect(type.coerce(3)).to eql(nil)
      expect(type.coerce_literal({ kind: :enum, value: 'B' })).to eql(2)
      expect(type.coerce_literal({ kind: :enum, value: 'C' })).to eql(nil)
      expect(type.values.keys.sort).to eql(['A', 'B'])
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
