require 'graphql/configuration'

module GraphQL


  # GraphQL Scalar Type Configuration
  #
  class GraphQLScalarTypeConfiguration < GraphQL::Configuration::Base
    slot :name,             String
    slot :description,      String, null: true
    slot :serialize,        Proc
    slot :parse_value,      Proc
    slot :parse_literal,    Proc
  end

  # GraphQL Scalar Type
  #
  class GraphQLScalarType < GraphQL::Configuration::Configurable

    include GraphQLType
    include GraphQLInputType
    include GraphQLOutputType
    include GraphQLLeafType
    include GraphQLNullableType
    include GraphQLNamedType

    configure_with GraphQLScalarTypeConfiguration

    def initialize(configuration)
      super
      raise RuntimeError.new("Name should present in #{self.class}") if name.nil? || name.size == 0
    end

    def serialize(value)
      @configuration.serialize.call(value)
    end

    def parse_value(value)
      @configuration.parse_value.call(value)
    end

    def parse_literal(ast)
      @configuration.parse_literal.call(ast)
    end

    def to_s
      name
    end

  end

  # Int
  #
  GraphQLInt = GraphQLScalarType.new do
    name 'Int'

    serialize lambda { |value|
      value = value.to_s
      return nil unless value =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
      value.to_f.round
    }

    parse_value serialize #-> (value) { serialize(value) }

    parse_literal lambda { |ast|
      ast[:kind] == :int ? ast[:value].to_i : nil
    }
  end

  # Float
  #
  GraphQLFloat = GraphQLScalarType.new do
    name 'Float'

    serialize lambda { |value|
      value = value.to_s
      return nil unless value =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
      value.to_f
    }

    parse_value serialize

    parse_literal lambda { |ast|
      ast[:kind] == :int || ast[:kind] == :float ? ast[:value].to_f : nil
    }
  end

  # String
  #
  GraphQLString = GraphQLScalarType.new do
    name 'String'

    serialize lambda { |value|
      value.to_s
    }

    parse_value serialize

    parse_literal lambda { |ast|
      ast[:kind] == :string ? ast[:value] : nil
    }
  end

  # Boolean
  #
  GraphQLBoolean = GraphQLScalarType.new do
    name 'Boolean'

    serialize lambda { |value|
      return false if value == 0
      !!value
    }

    parse_value serialize

    parse_literal lambda { |ast|
      ast[:kind] == :boolean ? ast[:value] : nil
    }
  end

  # ID
  #
  GraphQLID = GraphQLScalarType.new do
    name 'ID'

    serialize lambda { |value|
      value.to_s
    }

    parse_value serialize

    parse_literal lambda { |ast|
      ast[:kind] == :string || ast[:kind] == :int ? ast[:value] : nil
    }
  end

end
