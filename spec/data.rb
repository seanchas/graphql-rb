require 'graphql'

module StarWars

  EpisodeEnum = GraphQL::GraphQLEnumType.new do
    name          'Episode'
    description   'One of the films in the Star Wars Trilogy'

    value         'NEWHOPE',  4, description: 'Released in 1977'
    value         'EMPIRE',   5, description: 'Released in 1980'
    value         'JEDI',     6, description: 'Released in 1983'
  end

  CharacterInterface = GraphQL::GraphQLInterfaceType.new do
    name          'Character'
    description   'A character in the Star Wars Trilogy'

    field :id do
      type        GraphQL::GraphQLNonNull.new(GraphQL::GraphQLString)
      description 'The id of the character.'
    end

    field :name do
      type        GraphQL::GraphQLString
      description 'The name of the character.'
    end

    field :friends do
      type        -> { GraphQL::GraphQLList.new(CharacterInterface) }
      description 'The friends of the character, or an empty list if they have none.'
    end

    field :appears_in do
      type        GraphQL::GraphQLList.new(EpisodeEnum)
      description 'Which movies they appear in.'
    end

    resolve_type -> (type) { raise "Not implemented. Yet." }
  end


end
