require 'graphql'

RSpec.describe GraphQL::GraphQLTypeBase do

  def build_class
    Class.new(GraphQL::GraphQLTypeBase) do
      attribute :name
      attribute :description
    end
  end

  def build_instance(attributes = {})
    build_class.new(attributes)
  end


  it 'Should create GraphQLTypeBase class' do
    expect {
      build_class
    }.not_to raise_error
  end

  it 'Should create instance of GraphQLTypeBase class without initial value for attribute' do
    expect {
      instance = build_instance
      expect(instance.name).to eql(nil)
    }.not_to raise_error
  end

  it 'Should create instance of GraphQLTypeBase class with initial value for attribute' do
    expect {
      instance = build_instance(name: 'abc')
      expect(instance.name).to eql('abc')
      expect(instance.description).to eql(nil)
    }.not_to raise_error
  end

end
