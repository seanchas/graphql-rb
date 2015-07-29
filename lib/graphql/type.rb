require 'graphql/type/definable'
require 'graphql/type/configurable'
require 'graphql/type/base'
require 'graphql/type/scalar'
require 'graphql/type/list'
require 'graphql/type/non_null'
require 'graphql/type/field'
require 'graphql/type/object'

module GraphQL
  module Type

    Type            = [Scalar, Object, List, NonNull] # Scalar, Object, Interface, Union, Enum, InputObject, List, NonNull
    InputType       = [Scalar, List, NonNull] # Scalar, Enum, InputObject, List, NonNull
    OutputType      = [Scalar, Object, List, NonNull] # Scalar, Object, Interface, Union, Enum, List, NonNull
    LeafType        = [Scalar] # Scalar, Enum
    CompositeType   = [Object] # Object, Interface, Union
    AbstractType    = [] # Interface, Union
    NullableType    = [Scalar, Object, List] # Scalar, Object, Interface, Union, Enum, InputObject, List
    NamedType       = [Scalar, Object] # Scalar, Object, Interface, Union, Enum, InputObject


    def self.type?(type)
      Type.find { |t| type.class <= t }
    end


    def self.named_type(type)
      while type.is_a?(List) || type.is_a?(NonNull)
        type = type.of_type
      end
      type
    end


    def self.nullable_type(type)
      type.is_a?(NonNull) ? type.of_type : type
    end


  end
end
