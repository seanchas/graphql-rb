module GraphQL

  class GraphQLInterfaceTypeConfiguration < GraphQL::Configuration::Base
    slot :name,           String
    slot :fields,         [-> { GraphQLField }], singular: :field
    slot :resolve_type,   Proc,     null: true
    slot :description,    String,   null: true
  end

  class GraphQLInterfaceType < GraphQL::Configuration::Configurable

    include GraphQLType
    include GraphQLOutputType
    include GraphQLCompositeType
    include GraphQLAbstractType
    include GraphQLNullableType
    include GraphQLNamedType

    configure_with GraphQLInterfaceTypeConfiguration

    def initialize(configuration)
      super
      @implementations = []
    end

    def implement!(type)
      raise RuntimeError.new("#{self} can implement instances of GraphQLType. Got #{type.class}.") unless type.is_a?(GraphQLType)
      @implementations << type unless possible_type?(type)
    end

    def field_map
      @field_map ||= @configuration.fields.reduce({}) { |memo, field| memo[field.name.to_sym] = field ; memo}
    end

    def field_names
      @field_names ||= field_map.keys
    end

    def fields
      @fields ||= field_map.values
    end

    def field(name)
      field_map(name.to_sym)
    end

    def possible_types
      @implementations
    end

    def possible_type?(type)
      possible_types.include?(type)
    end

    def resolve_type(type)
      @configuration.resolve_type.nil? ? type_of(type) : @configuration.resolve_type.call(type)
    end

    def to_s
      name
    end
  end

end
