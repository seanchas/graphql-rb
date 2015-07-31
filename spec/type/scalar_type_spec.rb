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


  it 'Should convert instance to string' do
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
end
