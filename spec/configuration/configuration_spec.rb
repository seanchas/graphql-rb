require 'graphql'

RSpec.describe GraphQL::Configuration do

  it "should" do

    c = Class.new(GraphQL::Configuration::Base) do
      slot :name, String
      slot :arg,  [String]
    end

    t = Class.new(GraphQL::Configuration::Configurable) do
      configure_with c
    end

    i = t.new do
      name  'Func'
      arg   'abc'
      arg   'def'
      arg   'ghi'
    end

    puts i.name
    puts i.arg_list.inspect

  end

end
