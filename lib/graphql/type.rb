module GraphQL

  module GraphQLType; end
  module GraphQLInputType; end
  module GraphQLOutputType; end
  module GraphQLLeafType; end
  module GraphQLCompositeType; end
  module GraphQLAbstractType; end
  module GraphQLNamedType; end

  module GraphQLNullableType

    def !
      GraphQLNonNull.new(self)
    end

  end

  def named_type(type)
    type = type.of_type while type.is_a?(GraphQLList) || type.is_a?(GraphQLNonNull)
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
