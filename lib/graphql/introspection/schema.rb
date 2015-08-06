module GraphQL

  module Introspection

    Schema__ = GraphQLObjectType.new do

      name '__Schema'

      description   %(
                      A GraphQL Schema defines the capabilities of a GraphQL server. It exposes all available types and directives on
                      the server, as well as the entry points for query and mutation operations.
                    )

      field :types, -> { ! + ! Type__ } do
        description 'A list of all types supported by this server.'
        resolve -> (schema) { schema.type_map.values }
      end

      field :query_type, -> { ! Type__ } do
        description 'The type that query operations will be rooted at.'
        resolve -> (schema) { schema.query_type }
      end

      field :mutation_type, -> { ! Type__ } do
        description 'If this server supports mutation, the type that mutation operations will be rooted at.'
        resolve -> (schema) { schema.query_type }
      end

      field :directives, -> { ! + ! Type__ } do
        description 'A list of all directives supported by this server.'
        resolve -> (schema) { schema.directives }
      end

    end

    Directive__ = GraphQLObjectType.new do

      name '__Directive'

      field :name, ! GraphQLString
      field :description, GraphQLString

      field :args, -> { ! + ! InputValue__ } do
        resolve -> (directive) { directive.args }
      end

      field :on_operation,  ! GraphQLBoolean
      field :on_fragment,   ! GraphQLBoolean
      field :on_field,      ! GraphQLBoolean

    end

    Type__ = GraphQLObjectType.new do
      name '__Type'

      field :name,        GraphQLString
      field :description, GraphQLString

      field :kind, -> { ! TypeKind__ } do
        resolve lambda { |type|
          case type
          when GraphQLScalarType      then :scalar
          when GraphQLObjectType      then :object
          when GraphQLInterfaceType   then :interface
          when GraphQLUnionType       then :union
          when GraphQLEnumType        then :enum
          when GraphQLInputObjectType then :input_object
          when GraphQLList            then :list
          when GraphQLNonNull         then :non_null
          else raise RuntimeError.new("Unknown kind of type: #{type}")
          end
        }
      end

      field :fields, -> { + ! Field__ } do
        arg :include_deprecated, GraphQLBoolean, default_value: false

        resolve lambda { |type, params = {}|
          return nil unless type.is_a?(GraphQLObjectType) || type.is_a?(GraphQLInterfaceType)
          fields = type.fields.values
          fields = fields.select { |field| !field.deprecation_reason } unless params[:include_deprecated]
          fields
        }
      end

      field :interfaces, -> { + ! Type__ } do
        resolve lambda  { |type|
          type.interfaces if type.is_a?(GraphQLObjectType)
        }
      end

      field :possible_types, -> { + ! Type__ } do
        resolve lambda { |type|
          type.possible_types if type.is_a?(GraphQLInterfaceType) || type.is_a?(GraphQLUnionType)
        }
      end

      field :enum_values, -> { + ! EnumValue__ } do
        arg :include_deprecated, GraphQLBoolean, default_value: false

        resolve lambda { |type|
          return nil unless type.is_a?(GraphQLEnumType)
          values = type.values.values
          values = values.select { |value| !value.deprecation_reason } unless params[:include_deprecated]
          values
        }
      end

      field :input_fields, -> { + ! InputValue__ } do
        resolve lambda { |type|
          type.fields.values if type.is_a?(GraphQLInputObjectType)
        }
      end

      field :of_type, -> { Type__ }

    end

    Field__ = GraphQLObjectType.new do
      name '__Field'

      field :name,              ! GraphQLString
      field :description,         GraphQLString
      field :args,                -> { ! + ! InputValue__ }, resolve: -> (field) { field.args || [] }
      field :type,                -> { ! Type__ }
      field :is_deprecated,     ! GraphQLBoolean, resolve: -> (field) { !!field.deprecation_reason }
      field :deprecation_reason,  GraphQLString
    end

    InputValue__ = GraphQLObjectType.new do
      name '__InputValue'

      field :name,          ! GraphQLString
      field :description,     GraphQLString
      field :type,            -> { ! Type__ }
      field :default_value,   GraphQLString, resolve: -> (value) { value.default_value.nil? ? nil : raise("Not implemented. Yet.") }
    end

    EnumValue__ = GraphQLObjectType.new do
      name '__EnumValue'

      field :name,              ! GraphQLString
      field :description,         GraphQLString
      field :is_deprecated,     ! GraphQLBoolean, resolve: -> (value) { !!value.deprecation_reason }
      field :deprecation_reason,  GraphQLString
    end

    TypeKind__ = GraphQLEnumType.new do
      name          '__TypeKind'
      description   'An enum describing what kind of type a given __Type is'

      value :SCALAR,        :scalar,        'Indicates this type is a scalar.'
      value :OBJECT,        :object,        'Indicates this type is an object. `fields` and `interfaces` are valid fields.'
      value :INTERFACE,     :interface,     'Indicates this type is an interface. `fields` and `possible_types` are valid fields.'
      value :UNION,         :union,         'Indicates this type is a union. `possible_types` is a valid field.'
      value :ENUM,          :enum,          'Indicates this type is an enum. `values` is a valid field.'
      value :INPUT_OBJECT,  :input_object,  'Indicates this type is an input object. `fields` is a valid field.'
      value :LIST,          :list,          'Indicates this type is a list. `of_type` is a valid field.'
      value :NON_NULL,      :non_null,      'Indicates this type is a non-null. `of_type` is a valid field.'
    end
  end

end
