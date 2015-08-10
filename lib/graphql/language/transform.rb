require 'parslet'

module GraphQL
  module Language

    class Transform < Parslet::Transform

      rule(string_value:  simple(:a)) { { value: a.to_s,      kind: :string   } }
      rule(int_value:     simple(:a)) { { value: a.to_i,      kind: :int      } }
      rule(float_value:   simple(:a)) { { value: a.to_f,      kind: :float    } }
      rule(boolean_value: simple(:a)) { { value: a == 'true', kind: :boolean  } }

    end

  end
end
