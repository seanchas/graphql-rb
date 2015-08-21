require 'graphql'

RSpec.describe "Mutation Tests" do


  TheNumber = Struct.new('Number', :value)

  class TheNumber

    def self.number
      @number ||= TheNumber.new
    end

  end

  NumberHolderType = GraphQL::GraphQLObjectType.new do
    name 'NumberHolder'
    field :value, GraphQL::GraphQLInt
  end


  QueryType = GraphQL::GraphQLObjectType.new do
    name 'Query'
    field :numberHolder, NumberHolderType
  end


  MutationType = GraphQL::GraphQLObjectType.new do
    name 'Mutation'

    field :immediatelyChangeTheNumber, type: NumberHolderType do
      arg :newNumber, GraphQL::GraphQLInt

      resolve lambda { |object, params|
        TheNumber.number.value = params[:newNumber]
        return TheNumber.number
      }
    end

    field :futureChangeTheNumber, type: NumberHolderType do
      arg :newNumber, GraphQL::GraphQLInt

      resolve lambda { |object, params|
        GraphQL::Execution::Pool.future do
          raise "Cannot change the number"
          TheNumber.number.value = params[:newNumber]
          TheNumber.number
        end
      }
    end
  end


  Schema = GraphQL::GraphQLSchema.new do

    query     QueryType
    mutation  MutationType

  end



  it "Should evaluate mutations serially" do
    query = %q(
      mutation M {
        first: immediatelyChangeTheNumber(newNumber: 1) {
          value
        }
        second: futureChangeTheNumber(newNumber: 2) {
          value
        }
        third: immediatelyChangeTheNumber(newNumber: 3) {
          value
        }
        fourth: futureChangeTheNumber(newNumber: 4) {
          value
        }
        fifth: immediatelyChangeTheNumber(newNumber: 5) {
          value
        }
      }
    )

    puts GraphQL.graphql(Schema, query, {}, { newNumber: 1 })
  end


end
