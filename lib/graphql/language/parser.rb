require 'parslet'

module GraphQL
  module Language

    class Parser < Parslet::Parser

      rule(:root) { document }

      # Source Character
      #

      rule(:source_character) { any }

      # Ignored Tokens
      #

      rule(:ignored) { white_space | line_terminator | comment | comma }

      rule(:ignored?) { ignored.repeat(0) }

      rule(:ignored!) { ignored.repeat(1) }

      rule(:white_space) { match('[\u0009\u000b\u000c\u0020\u00a0]') }

      rule(:line_terminator) { match('[\u000a\u000d\u2028\u2029]') }

      rule(:comment) { str('#') >> comment_char.repeat }

      rule(:comment_char) { line_terminator.absent? >> source_character }

      rule(:comma) { str(',') }

      # Lexical Tokens
      #

      rule(:token) { punctuator | name | int_value | float_value | string_value }

      rule(:punctuator) { match('[!$():=@[]{|}]') | str('...') }

      rule(:name) { (match('[_a-zA-Z]') >> match('[_a-zA-Z0-9]').repeat).as(:name) }

      rule(:int_value) { integer_part.as(:int_value) }

      rule(:integer_part) { negative_sign.maybe >> str('0') | negative_sign.maybe >> non_zero_digit >> digit.repeat }

      rule(:negative_sign) { str('-') }

      rule(:digit) { match('[0-9]') }

      rule(:non_zero_digit) { str('0').absent? >> digit }

      rule(:float_value) { (integer_part >> fractional_part >> exponent_part | integer_part >> fractional_part | integer_part >> exponent_part).as(:float_value) }

      rule(:fractional_part) { str('.') >> digit.repeat(1) }

      rule(:exponent_part) { exponent_indicator >> sign.maybe >> digit.repeat(1) }

      rule(:exponent_indicator) { match('[eE]') }

      rule(:sign) { match('-+') }

      rule(:string_value) { (str('""') |  str('"') >> string_character.repeat(1).as(:value) >> str('"')).as(:string_value) }

      rule(:string_character) { (str('"') | str('\\') | line_terminator).absent? >> source_character | str('\\') >> escaped_unicode | str('\\') >> escaped_character  }

      rule(:escaped_unicode) { str('u') >> match('[a-fA-F0-9]').repeat(4) }

      rule(:escaped_character) { match('["\\/bfnrt]') }

      # Query Document
      #

      rule(:document) { ignored? >> definition.repeat(1).as(:document_definitions) >> ignored? }

      rule(:definition) { operation_definition | fragment_definition }

      rule(:operation_definition) { selection_set | operation_type.as(:type) >> ignored! >> name.as(:name) >> variable_definitions.maybe.as(:variable_definitions) >> directives.maybe.as(:directives) >> selection_set.as(:selection_set) }

      rule(:operation_type) { str('query') | str('mutation') }

      rule(:selection_set) { ignored? >> str('{') >> selection.repeat(1).as(:selections) >> str('}') >> ignored? }

      rule(:selection) { ignored? >> field >> ignored? | fragment_spread | inline_fragment }

      rule(:field) { field_alias.maybe.as(:alias) >> name.as(:name) >> arguments.maybe.as(:arguments) >> directives.maybe.as(:directives) >> selection_set.maybe.as(:selection_set) }

      rule(:field_alias) { name >> str(':') >> ignored? }

      rule(:arguments) { str('(') >> argument.repeat(1) >> str(')') }

      rule(:argument) { ignored? >> name.as(:name) >> str(':') >> ignored? >> value.as(:value) >> ignored? }

      rule(:fragment_spread) { str('...') >> fragment_name >> directives.maybe }

      rule(:inline_fragment) { str('...') >> str('on') >> type_condition >> directives.maybe >> selection_set }

      rule(:fragment_definition) { str('fragment') >> fragment_name >> str('on') >> type_condition >> directives.maybe >> selection_set }

      rule(:fragment_name) { str('on').absent? >> name }

      rule(:type_condition) { named_type }

      rule(:value) { variable | float_value | int_value | string_value | boolean_value | enum_value | list_value | object_value }

      rule(:value_const) { float_value | int_value | string_value | boolean_value | enum_value | list_value_const | object_value_const }

      rule(:boolean_value) { str('true') | str('false') }

      rule(:enum_value) { (str('true') | str('false') | str('null')).absent? >> name }

      rule(:list_value) { str('[') >> str(']') | str('[') >> value.repeat(1) >> str(']') }

      rule(:list_value_const) { str('[') >> str(']') | str('[') >> value_const.repeat(1) >> str(']') }

      rule(:object_value) { str('{') >> str('}') | str('{') >> object_field.repeat(1) >> str('}') }

      rule(:object_value_const) { str('{') >> str('}') | str('{') >> object_field_const.repeat(1) >> str('}') }

      rule(:object_field) { name >> str(':') >> value }

      rule(:object_field_const) { name >> str(':') >> value_const }

      rule(:variable_definitions) { str('(') >> variable_definition.repeat(1) >> str(')') }

      rule(:variable_definition) { variable >> str(':') >> ignored? >> type.as(:type) >> default_value.maybe.as(:default_value) }

      rule(:variable) { (ignored? >> str('$') >> name.as(:name) >> ignored?).as(:variable) }

      rule(:default_value) { ignored? >> str('=') >> ignored? >> value_const >> ignored? }

      rule(:type) { non_null_type | list_type | named_type }

      rule(:named_type) { name }

      rule(:list_type) { str('[') >> type >> str(']') }

      rule(:non_null_type) { list_type >> str('!') | named_type >> str('!') }

      rule(:directives) { directive.repeat(1) }

      rule(:directive) { str('@') >> name >> arguments.maybe }

    end

  end
end
