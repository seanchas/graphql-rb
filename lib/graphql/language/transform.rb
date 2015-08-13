require 'parslet'

module GraphQL
  module Language

    class Transform < Parslet::Transform


      rule(document: sequence(:a)) { Document.new(a) }


      rule(operation_definition: {
        type:                    simple(:a),
        name:                    simple(:b),
        variable_definitions:   subtree(:c),
        directives:             subtree(:d),
        selection_set:           simple(:e)
      }) { OperationDefinition.new(a, b, c, d, e) }

      rule(operation_definition: {
        selection_set: simple(:a)
      }) { OperationDefinition.new('query', nil, nil, nil, a) }


      rule(fragment_definition: {
        name:              simple(:a),
        type_condition:   subtree(:b),
        directives:       subtree(:c),
        selection_set:     simple(:d)
      }) { FragmentDefinition.new(a, b, c, d) }


      rule(fragment_spread: {
        name:         simple(:a),
        directives:   subtree(:b)
      }) { FragmentSpread.new(a, b) }


      rule(inline_fragment: {
        type_condition:   subtree(:a),
        directives:       subtree(:b),
        selection_set:     simple(:c)
      }) { InlineFragment.new(a, b, c) }


      rule(field: {
        alias:           simple(:a),
        name:            simple(:b),
        arguments:      subtree(:c),
        directives:     subtree(:d),
        selection_set:   simple(:e)
      }) { Field.new(a, b, c, d, e) }


      rule(directive: {
        name:       simple(:a),
        arguments:  subtree(:b)
      }) { Directive.new(a, b) }


      rule(argument: {
        name:   simple(:a),
        value:  simple(:b)
      }) { Argument.new(a, b) }


      rule(selection_set: {
        selections: subtree(:a)
      }) { SelectionSet.new(a) }


      rule(variable_definition: {
        variable:       simple(:a),
        type:           simple(:b),
        default_value:  simple(:c)
      }) { VariableDefinition.new(a, b, c) }


      rule(variable: simple(:a)) { Variable.new(a) }

      rule(named_type:      simple(:a)) { NamedType.new(a)    }
      rule(list_type:       simple(:a)) { ListType.new(a)     }
      rule(non_null_type:   simple(:a)) { NonNullType.new(a)  }

      rule(name: simple(:a)) { a.to_s }

      rule(value: simple(:a)) { a }
      rule(value: subtree(:a)) { Value.new(a[:kind], a[:value]) }

      rule(string_value:    simple(:a)) { { value: a.to_s,      kind: :string   } }
      rule(int_value:       simple(:a)) { { value: a.to_i,      kind: :int      } }
      rule(float_value:     simple(:a)) { { value: a.to_f,      kind: :float    } }
      rule(boolean_value:   simple(:a)) { { value: a == 'true', kind: :boolean  } }
      rule(enum_value:      simple(:a)) { { value: a,           kind: :enum     } }
      rule(list_value:    sequence(:a)) { { value: a,           kind: :list     } }
      rule(object_value:   subtree(:a)) { { value: a,           kind: :object   } }

    end

  end
end
