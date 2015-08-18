require 'graphql'
require_relative '../schema'

RSpec.describe "Introspection - Simple" do

  def q1
    %Q(
      query Introspection {
        __schema {
          types {
            name
          }
        }
      }
    )
  end


  def q2
    %Q(
      query Introspection {
        __schema {
          queryType {
            name
          }
        }
      }
    )
  end


  def q3
    %Q(
      query Introspection {
        __type(name: "Droid") {
          name
        }
      }
    )
  end


  def q4
    %Q(
      query Introspection {
        __type(name: "Droid") {
          name
          kind
        }
      }
    )
  end


  def q5
    %Q(
      query Introspection {
        __type(name: "Character") {
          name
          kind
        }
      }
    )
  end


  def q6
    %Q(
      query Introspection {
        __type(name: "Droid") {
          name
          fields {
            name
            type {
              name
              kind
            }
          }
        }
      }
    )
  end


  it "Should allow querying the schema for types" do
    expectation = {
      data: {
        __schema: {
          types: [
            { name: "Query"         },
            { name: "Episode"       },
            { name: "Character"     },
            { name: "Human"         },
            { name: "String"        },
            { name: "Droid"         },
            { name: "__Schema"      },
            { name: "__Type"        },
            { name: "__TypeKind"    },
            { name: "Boolean"       },
            { name: "__Field"       },
            { name: "__InputValue"  },
            { name: "__EnumValue"   }
          ]
        }
      }
    }

    result = GraphQL::graphql(StarWars::Schema, q1, {}, {})

    expect(result).to eql(expectation)
  end

  it "Should allow querying the schema for query type" do
    expectation = {
      data: { __schema: { queryType: { name: "Query" } } }
    }

    result = GraphQL::graphql(StarWars::Schema, q2, {}, {})

    expect(result).to eql(expectation)
  end

  it "Should allow querying the schema for a specific type" do
    expectation = {
      data: { __type: { name: 'Droid' } }
    }

    result = GraphQL::graphql(StarWars::Schema, q3, {}, {})

    expect(result).to eql(expectation)
  end

  it "Should allow querying the schema for an object kind" do
    expectation = {
      data: { __type: { name: 'Droid', kind: 'OBJECT' } }
    }

    result = GraphQL::graphql(StarWars::Schema, q4, {}, {})

    expect(result).to eql(expectation)
  end

  it "Should allow querying the schema for an interface kind" do
    expectation = {
      data: { __type: { name: 'Character', kind: 'INTERFACE' } }
    }

    result = GraphQL::graphql(StarWars::Schema, q5, {}, {})

    expect(result).to eql(expectation)
  end

end
