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


  it 'Should validate GraphQLScalarType' do
    expect(valid_scalar.valid?).to eql(true)
  end

  it 'Should not validate GraphQLScalarType' do
    expect(invalid_scalar.valid?).to eql(false)
  end

end
