module GraphQL

  # GraphQL Scalar Type
  #
  class GraphQLScalarType < GraphQLTypeBase

    attribute :name,            type: String
    attribute :description,     type: String, allow_null: true
    attribute :coerce,          type: Proc
    attribute :coerce_literal,  type: Proc

    def coerce(value)
      @configuration.coerce.call(value)
    end

    def coerce_literal(ast)
      # TODO: check if ast is a GraphQLValue type
      @configuration.coerce_literal.nil? ? nil : @configuration.coerce_literal.call(ast)
    end

    def to_s
      name
    end

  end

  # Int
  #
  GraphQLInt = GraphQLScalarType.new do
    name 'Int'

    coerce lambda { |value|
      value = value.to_s
      return nil unless value =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
      value.to_f.round
    }

    coerce_literal lambda { |ast|
      ast[:kind] == :int ? ast[:value].to_i : nil
    }
  end

  # Float
  #
  GraphQLFloat = GraphQLScalarType.new do
    name 'Float'

    coerce lambda { |value|
      value = value.to_s
      return nil unless value =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
      value.to_f
    }

    coerce_literal lambda { |ast|
      ast[:kind] == :int || ast[:kind] == :float ? ast[:value].to_f : nil
    }
  end

  # String
  #
  GraphQLString = GraphQLScalarType.new do
    name 'String'

    coerce lambda { |value|
      value.to_s
    }

    coerce_literal lambda { |ast|
      ast[:kind] == :string ? ast[:value] : nil
    }
  end

  # Boolean
  #
  GraphQLBoolean = GraphQLScalarType.new do
    name 'Boolean'

    coerce lambda { |value|
      return false if value == 0
      !!value
    }

    coerce_literal lambda { |ast|
      ast[:kind] == :boolean ? ast[:value] : nil
    }
  end

  # ID
  #
  GraphQLID = GraphQLScalarType.new do
    name 'ID'

    coerce lambda { |value|
      value.to_s
    }

    coerce_literal lambda { |ast|
      ast[:kind] == :string || ast[:kind] == :int ? ast[:value] : nil
    }
  end

end
