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


  it 'Should create instance with initial value' do
    expect {
      instance = build_instance(name: 'abc')
      expect(instance.name).to eql('abc')
      expect(instance.description).to eql(nil)
    }.not_to raise_error
  end

  it 'Should create instance without initial value' do
    expect {
      instance = build_instance
      expect(instance.name).to eql(nil)
    }.not_to raise_error
  end

end
