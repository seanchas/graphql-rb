require 'graphql'

RSpec.describe GraphQL::GraphQLEnumType do

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
    expect(rgb_type.serialize(1)).to eql('RED')
    expect(rgb_type.serialize('BLUE')).to eql('BLUE')
    expect(rgb_type.parse_value('GREEN')).to eql(2)
    expect(rgb_type.parse_literal(kind: :enum, value: 'GREEN')).to eql(2)
  end

end
