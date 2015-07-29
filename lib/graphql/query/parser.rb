module GraphQL
  module Query

    class Parser < Parslet::Parser
      root(:document)

      rule(:document) {
        space.maybe >> fields >> space.maybe
      }

      rule(:fields) {
        field >> ( space.maybe >> comma.maybe >> field).repeat
      }

      rule(:field) {
        name.as(:field_name) >> arguments.maybe.as(:field_arguments) >> selections.maybe.as(:field_selections)
      }

      rule(:arguments) {
        str('(') >> (argument >> (comma >> argument).repeat).maybe >> str(')')
      }

      rule(:argument) {
        name.as(:argument_name) >> str(':') >> space.maybe >> string.as(:argument_value) >> space.maybe
      }

      rule(:selections) {
        space.maybe >> str('{') >> space.maybe >> fields.maybe >> space.maybe >> str('}')
      }

      rule(:space) {
        match('[\s]').repeat(1)
      }

      rule(:comma) {
        str(',') >> space.maybe
      }

      rule(:name) {
        match('[_a-zA-Z]') >> match('[_a-zA-Z0-9]').repeat
      }

      rule(:string) {
        str('"') >> match('[^\"]').repeat(1).as(:string) >> str('"')
      }
    end

  end
end
