require 'graphql'

RSpec.describe GraphQL::GraphQLScalarType do

  def valid_scalar
    GraphQL::GraphQLScalarType.new do
      name            'String Scalar'
      description     'String Scalar Description'
      serialize       -> (value) { value.to_s }
      parse_literal   -> (value) { raise 'Not implemented' }
    end
  end

  def invalid_scalar
    GraphQL::GraphQLScalarType.new
  end

  def string
    GraphQL::GraphQLString
  end

  def int
    GraphQL::GraphQLInt
  end

  def float
    GraphQL::GraphQLFloat
  end

  def boolean
    GraphQL::GraphQLBoolean
  end

  def id
    GraphQL::GraphQLID
  end

  it 'Should perform to_s' do
    expect(valid_scalar.to_s).to eql(valid_scalar.name)
  end

  it 'Should coerce' do
    expect(valid_scalar.serialize('ABC')).to eql('ABC')
    expect(valid_scalar.serialize(123)).to eql('123')
  end

  it 'Should not coerce' do
    expect { valid_scalar.parse_literal('ABC') }.to raise_error('Not implemented')
  end

  # Int
  #
  it 'Should coerce value to int' do
    expect(int.serialize('123')).to eql(123)
    expect(int.serialize(123.45)).to eql(123)
    expect(int.serialize(123.5)).to eql(124)
    expect(int.serialize(-123.5)).to eql(-124)
  end

  it 'Should not coerce value to int' do
    expect(int.serialize('abc')).to eql(nil)
    expect(int.parse_literal(kind: :string, value: '123')).not_to eql(123)
  end


  # Float
  #
  it 'Should coerce value to float' do
    expect(float.serialize('123')).to eql(123.0)
    expect(float.serialize(123)).to eql(123.0)
  end

  it 'Should not coerce value to float' do
    expect(float.serialize('abc')).to eql(nil)
    expect(float.parse_literal(kind: :string, value: '123')).not_to eql(123)
  end


  # String
  #
  it 'Should coerce value to string' do
    expect(string.serialize('abc')).to eql('abc')
    expect(string.serialize(:abc)).to eql('abc')
    expect(string.serialize(123)).to eql('123')
    expect(string.serialize(123.45)).to eql('123.45')
    expect(string.serialize(true)).to eql('true')

    expect(string.parse_literal(kind: :string, value: 'abc')).to eql('abc')
  end

  it 'Should not coerce value to string' do
    expect(string.parse_literal(kind: :int, value: 123)).to eql(nil)
  end

  # Boolean
  #
  it 'Should coerce value to boolean' do
    expect(boolean.serialize('true')).to eql(true)
    expect(boolean.serialize(0)).to eql(false)
  end

  it 'Should not coerce value to boolean' do
    expect(boolean.parse_literal(kind: :string, value: '123')).not_to eql(123)
  end

  # ID
  #
  it 'Should coerce value to id' do
    expect(id.serialize(123)).to eql('123')
    expect(id.serialize('abc')).to eql('abc')
  end

  it 'Should not coerce value to id' do
    expect(boolean.parse_literal(kind: :string, value: '123')).not_to eql(123)
  end

end
