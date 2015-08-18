module GraphQL
  module Introspection

    SchemaMetaField = GraphQLField.new do
      name '__schema'
      type ! Schema__

      description 'Access the current type schema of this server.'

      resolve -> (root, params, context) { context[:schema] }
    end

    TypeMetaField = GraphQLField.new do
      name '__type'
      type Type__

      description 'Request the type information of a single type.'

      arg :name, ! GraphQLString

      resolve -> (root, params, context) { context[:schema].type(params[:name]) }
    end

    TypeNameMetaField = GraphQLField.new do
      name '__typename'
      type ! GraphQLString

      description 'The name of the current Object type at runtime.'

      resolve -> (root, params, context) { context[:parent_type].name }
    end

    def self.meta_field_map
      [SchemaMetaField, TypeMetaField].reduce({}) { |memo, field| memo[field.name.to_sym] = field ; memo }
    end

    def self.meta_field_names
      @meta_field_names ||= meta_field_map.keys
    end

    def self.meta_fields
      @meta_fields ||= meta_field_map.values
    end

    def self.meta_field(name)
      meta_field_map[name.to_sym]
    end

    def self.meta_field?(name)
      !!meta_field(name)
    end

  end
end
