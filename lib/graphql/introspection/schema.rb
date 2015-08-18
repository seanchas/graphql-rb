module GraphQL
  module Introspection

    Schema__ = GraphQLObjectType.new do

      name '__Schema'

      description  'A GraphQL Schema defines the capabilities of a GraphQL server. It exposes all available types ' +
        'and directives on the server, as well as the entry points for query and mutation operations.'

      field :types, -> { ! + ! Type__ } do
        description 'A list of all types supported by this server.'
        resolve -> (schema) { schema.type_map.values }
      end

      field :queryType, -> { ! Type__ } do
        description 'The type that query operations will be rooted at.'
        resolve -> (schema) { schema.query_type }
      end

      field :mutationType, -> { ! Type__ } do
        description 'If this server supports mutation, the type that mutation operations will be rooted at.'
        resolve -> (schema) { schema.mutation_type }
      end

      field :directives, -> { ! + ! Type__ } do
        description 'A list of all directives supported by this server.'
      end

    end

    Directive__ = GraphQLObjectType.new do

      name '__Directive'

      field :name,          ! GraphQLString
      field :description,     GraphQLString

      field :args,          -> { ! + ! InputValue__ }

      field :onOperation,   ! GraphQLBoolean,  resolve: -> (directive) { directive.on_operation }
      field :onFragment,    ! GraphQLBoolean,  resolve: -> (directive) { directive.on_fragment }
      field :onField,       ! GraphQLBoolean,  resolve: -> (directive) { directive.on_field }

    end

    Type__ = GraphQLObjectType.new do
      name '__Type'

      field :name,        GraphQLString, resolve: -> (type) { type.name rescue nil }
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
        arg :includeDeprecated, GraphQLBoolean, default_value: false

        resolve lambda { |type, params|
          return nil unless type.is_a?(GraphQLObjectType) || type.is_a?(GraphQLInterfaceType)
          fields = type.fields
          fields = fields.select { |field| !field.deprecation_reason } unless params[:includeDeprecated]
          fields
        }
      end

      field :interfaces, -> { + ! Type__ } do
        resolve lambda  { |type|
          type.interfaces if type.is_a?(GraphQLObjectType)
        }
      end

      field :possibleTypes, -> { + ! Type__ } do
        resolve lambda { |type|
          type.possible_types if type.is_a?(GraphQLInterfaceType) || type.is_a?(GraphQLUnionType)
        }
      end

      field :enumValues, -> { + ! EnumValue__ } do

        arg :includeDeprecated, GraphQLBoolean, default_value: false

        resolve lambda { |type, params|
          return nil unless type.is_a?(GraphQLEnumType)
          values = type.values
          values = values.select { |value| !value.deprecation_reason } unless params[:includeDeprecated]
          values
        }
      end

      field :inputFields, -> { + ! InputValue__ } do
        resolve lambda { |type|
          type.fields.values if type.is_a?(GraphQLInputObjectType)
        }
      end

      field :ofType, -> { Type__ }, resolve: -> (type) { type.of_type rescue nil }

    end

    Field__ = GraphQLObjectType.new do
      name '__Field'

      field :name,              ! GraphQLString
      field :description,         GraphQLString
      field :args,                -> { ! + ! InputValue__ }
      field :type,                -> { ! Type__ }
      field :isDeprecated,      ! GraphQLBoolean,   resolve: -> (field) { !!field.deprecation_reason }
      field :deprecationReason,   GraphQLString,    resolve: -> (field) { field.deprecation_reason }
    end

    InputValue__ = GraphQLObjectType.new do
      name '__InputValue'

      field :name,          ! GraphQLString
      field :description,     GraphQLString
      field :type,            -> { ! Type__ }
      field :defaultValue,   GraphQLString, resolve: -> (value) { value.default_value }
    end

    EnumValue__ = GraphQLObjectType.new do
      name '__EnumValue'

      field :name,              ! GraphQLString
      field :description,         GraphQLString
      field :isDeprecated,      ! GraphQLBoolean, resolve: -> (value) { !!value.deprecation_reason }
      field :deprecationReason,   GraphQLString,  resolve: -> (value) { value.deprecation_reason }
    end

    TypeKind__ = GraphQLEnumType.new do
      name          '__TypeKind'
      description   'An enum describing what kind of type a given __Type is'

      value :SCALAR,        :scalar,        'Indicates this type is a scalar.'
      value :OBJECT,        :object,        'Indicates this type is an object. `fields` and `interfaces` are valid fields.'
      value :INTERFACE,     :interface,     'Indicates this type is an interface. `fields` and `possibleTypes` are valid fields.'
      value :UNION,         :union,         'Indicates this type is a union. `possibleTypes` is a valid field.'
      value :ENUM,          :enum,          'Indicates this type is an enum. `values` is a valid field.'
      value :INPUT_OBJECT,  :input_object,  'Indicates this type is an input object. `fields` is a valid field.'
      value :LIST,          :list,          'Indicates this type is a list. `ofType` is a valid field.'
      value :NON_NULL,      :non_null,      'Indicates this type is a non-null. `ofType` is a valid field.'
    end

  end
end
