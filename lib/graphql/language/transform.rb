require 'parslet'

module GraphQL
  module Language

    class Transform < Parslet::Transform


      rule(definitions: sequence(:a)) { Document.new(a) }


      rule(operation_definition: {
        type:                    simple(:a),
        name:                    simple(:b),
        variable_definitions:   subtree(:c),
        directives:             subtree(:d),
        selection_set:          subtree(:e)
      }) { OperationDefinition.new(a, b, c, d, e) }

      rule(operation_definition: {
        selection_set: subtree(:a)
      }) { OperationDefinition.new(nil, nil, nil, nil, a) }


      rule(fragment_definition: {
        name:              simple(:a),
        type_condition:   subtree(:b),
        directives:       subtree(:c),
        selection_set:    subtree(:d)
      }) { FragmentDefinition.new(a, b, c, d) }


      rule(field: {
        alias:           simple(:a),
        name:            simple(:b),
        arguments:     sequence(:c),
        directives:    sequence(:d),
        selection_set:  subtree(:e)
      }) { Field.new(a, b, c, d, e) }


      rule(directive: {
        name:       simple(:a),
        arguments:  sequence(:b)
      }) { Directive.new(a, b) }

      rule(argument: {
        name:   simple(:a),
        value:  simple(:b)
      }) { Argument.new(a, b) }

      rule(value: subtree(:a)) { Value.new(a[:kind], a[:value]) }

      rule(name: simple(:a)) { a.to_s }

      rule(string_value:  simple(:a)) { { value: a.to_s,      kind: :string   } }
      rule(int_value:     simple(:a)) { { value: a.to_i,      kind: :int      } }
      rule(float_value:   simple(:a)) { { value: a.to_f,      kind: :float    } }
      rule(boolean_value: simple(:a)) { { value: a == 'true', kind: :boolean  } }

    end

  end
end
