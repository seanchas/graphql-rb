module GraphQL

  module GraphQLType
    def +@
      GraphQLList.new(self)
    end
  end

  module GraphQLInputType
  end

  module GraphQLOutputType
  end

  module GraphQLLeafType
  end

  module GraphQLCompositeType
  end

  module GraphQLNamedType
  end

  module GraphQLAbstractType

    def type_of(value)
      raise "Not implemented. Yet."
    end

  end

  module GraphQLNullableType

    def !
      GraphQLNonNull.new(self)
    end

  end

  def named_type(type)
    type = type.of_type while type.is_a?(GraphQLList) || type.is_a?(GraphQLNonNull)
  end

  TypeMapReducer = lambda do |memo, type|
    return TypeMapReducer.call(memo, type.of_type) if type.is_a?(GraphQLNonNull) || type.is_a?(GraphQLList)

    return memo if type.nil? || memo.keys.include?(type.name)

    memo[type.name] = type

    if type.is_a?(GraphQLUnionType) || type.is_a?(GraphQLInterfaceType)
      memo = type.possible_types.reduce(memo, &TypeMapReducer)
    end

    if type.is_a?(GraphQLObjectType)
      memo = type.interfaces.reduce(memo, &TypeMapReducer)
    end

    if type.is_a?(GraphQLObjectType) || type.is_a?(GraphQLInterfaceType)
      type.fields.each do |name, field|
        memo = field.args.map(&:type).reduce(memo, &TypeMapReducer)
        memo = TypeMapReducer.call(memo, field.type)
      end
    end

    memo
  end

end

require_relative 'type/scalar_type'
require_relative 'type/object_type'
require_relative 'type/interface_type'
require_relative 'type/union_type'
require_relative 'type/enum_type'
require_relative 'type/input_object_type'
require_relative 'type/field'
require_relative 'type/argument'
require_relative 'type/list'
require_relative 'type/non_null'
require_relative 'type/schema'
require_relative 'introspection/schema'
