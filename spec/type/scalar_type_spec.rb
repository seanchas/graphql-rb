require 'graphql'

RSpec.describe GraphQL::GraphQLScalarType do

  def valid_scalar
    GraphQL::GraphQLScalarType.new do
      name            'String Scalar'
      description     'String Scalar Description'
      coerce          -> (value) { value.to_s }
      coerce_literal  -> (value) { raise 'Not implemented' }
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
    expect(valid_scalar.coerce('ABC')).to eql('ABC')
    expect(valid_scalar.coerce(123)).to eql('123')
  end

  it 'Should not coerce' do
    expect { valid_scalar.coerce_literal('ABC') }.to raise_error('Not implemented')
  end

  it 'Should validate' do
    expect(valid_scalar.valid?).to eql(true)
  end

  it 'Should not validate' do
    expect(invalid_scalar.valid?).to eql(false)
  end


  # Int
  #
  it 'Should coerce value to int' do
    expect(int.coerce('123')).to eql(123)
    expect(int.coerce(123.45)).to eql(123)
    expect(int.coerce(123.5)).to eql(124)
    expect(int.coerce(-123.5)).to eql(-124)
  end

  it 'Should not coerce value to int' do
    expect(int.coerce('abc')).to eql(nil)
    expect(int.coerce_literal(kind: :string, value: '123')).not_to eql(123)
  end


  # Float
  #
  it 'Should coerce value to float' do
    expect(float.coerce('123')).to eql(123.0)
    expect(float.coerce(123)).to eql(123.0)
  end

  it 'Should not coerce value to float' do
    expect(float.coerce('abc')).to eql(nil)
    expect(float.coerce_literal(kind: :string, value: '123')).not_to eql(123)
  end


  # String
  #
  it 'Should coerce value to string' do
    expect(string.coerce('abc')).to eql('abc')
    expect(string.coerce(:abc)).to eql('abc')
    expect(string.coerce(123)).to eql('123')
    expect(string.coerce(123.45)).to eql('123.45')
    expect(string.coerce(true)).to eql('true')

    expect(string.coerce_literal(kind: :string, value: 'abc')).to eql('abc')
  end

  it 'Should not coerce value to string' do
    expect(string.coerce_literal(kind: :int, value: 123)).to eql(nil)
  end

  # Boolean
  #
  it 'Should coerce value to boolean' do
    expect(boolean.coerce('true')).to eql(true)
    expect(boolean.coerce(0)).to eql(false)
  end

  it 'Should not coerce value to boolean' do
    expect(boolean.coerce_literal(kind: :string, value: '123')).not_to eql(123)
  end

  # ID
  #
  it 'Should coerce value to id' do
    expect(id.coerce(123)).to eql('123')
    expect(id.coerce('abc')).to eql('abc')
  end

  it 'Should not coerce value to id' do
    expect(boolean.coerce_literal(kind: :string, value: '123')).not_to eql(123)
  end

end
