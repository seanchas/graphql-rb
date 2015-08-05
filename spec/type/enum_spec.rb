require 'graphql'

RSpec.describe GraphQL::GraphQLEnumType do

  def value(*args, &block)
    GraphQL::GraphQLEnumValueConfiguration
  end

  def type(*args, &block)
    GraphQL::GraphQLEnumType.new(*args, &block)
  end

  def rgb_type
    @rgb_type ||= type do
      name  'RGB'
      value :RED,    1
      value :GREEN,  2
      value :BLUE
      value :ALPHA,  description: 'Alpha channel'
    end
  end

  it "Should create RGB Enum" do
    expect { rgb_type }.not_to raise_error
    expect(rgb_type.coerce(1)).to eql('RED')
    expect(rgb_type.coerce('BLUE')).to eql('BLUE')
    expect(rgb_type.coerce_literal(kind: :enum, value: 'GREEN')).to eql(2)
  end

end
