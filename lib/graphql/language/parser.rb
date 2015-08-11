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

      rule(:integer_part) do
        negative_sign.maybe >> str('0')                       |
        negative_sign.maybe >> non_zero_digit >> digit.repeat
      end

      rule(:negative_sign) { str('-') }

      rule(:digit) { match('[0-9]') }

      rule(:non_zero_digit) { str('0').absent? >> digit }

      rule(:fractional_part) { str('.') >> digit.repeat(1) }

      rule(:exponent_part) { exponent_indicator >> sign.maybe >> digit.repeat(1) }

      rule(:exponent_indicator) { match('[eE]') }

      rule(:sign) { match('-+') }

      rule(:string_character) do
        (str('"') | str('\\') | line_terminator).absent? >> source_character  |
        str('\\') >> escaped_unicode                                          |
        str('\\') >> escaped_character
      end

      rule(:escaped_unicode) { str('u') >> match('[a-fA-F0-9]').repeat(4) }

      rule(:escaped_character) { match('["\\/bfnrt]') }

      rule(:name) do
        (match('[_a-zA-Z]') >> match('[_a-zA-Z0-9]').repeat).as(:name)
      end

      rule(:string_value) do
        str('"') >> string_character.repeat.as(:string_value) >> str('"')
      end

      rule(:int_value) do
        integer_part.as(:int_value)
      end

      rule(:float_value) do
        (
          integer_part >> fractional_part >> exponent_part  |
          integer_part >> fractional_part                   |
          integer_part >> exponent_part
        ).as(:float_value)
      end

      # Query Document
      #

      rule(:document) do
        ignored? >> definition.repeat(1).as(:document) >> ignored?
      end

      rule(:definition) do
        ignored? >> (operation_definition | fragment_definition) >> ignored?
      end

      rule(:operation_definition) do
         ignored? >> (
           selection_set.as(:selection_set)                       |
           operation_type.as(:type)                               >>
           name.as(:name)                                         >>
           variable_definitions.maybe.as(:variable_definitions)   >>
           directives.maybe.as(:directives)                       >>
           selection_set.as(:selection_set)
         ).as(:operation_definition) >> ignored?
      end

      rule(:operation_type) do
        ignored? >> (str('query') | str('mutation')).as(:name) >> ignored?
      end

      rule(:selection_set) do
        ignored? >> (str('{') >> selection.repeat(1).as(:selections) >> str('}')).as(:selection_set) >> ignored?
      end

      rule(:selection) do
        ignored? >> (field | fragment_spread | inline_fragment) >> ignored?
      end

      rule(:field) do
        ignored? >> (
          field_alias.maybe.as(:alias)            >>
          name.as(:name)                          >>
          arguments.maybe.as(:arguments)          >>
          directives.maybe.as(:directives)        >>
          selection_set.maybe.as(:selection_set)
        ).as(:field) >> ignored?
      end

      rule(:field_alias) do
        ignored? >> name >> str(':') >> ignored?
      end

      rule(:arguments) do
        ignored? >> (
          str('(') >> argument.repeat(1) >> str(')')
        ) >> ignored?
      end

      rule(:argument) do
        ignored? >> (
          name.as(:name)    >>
          str(':')          >>
          value.as(:value)
        ).as(:argument) >> ignored?
      end

      rule(:fragment_spread) do
        ignored? >> (
          str('...')                        >>
          fragment_name.as(:name)           >>
          directives.maybe.as(:directives)
        ).as(:fragment_spread) >> ignored?
      end

      rule(:inline_fragment) do
        ignored? >> (
          str('...')                          >>
          ignored?                            >>
          str('on')                           >>
          ignored?                            >>
          type_condition.as(:type_condition)  >>
          directives.maybe.as(:directives)    >>
          selection_set.as(:selection_set)
        ).as(:inline_fragment) >> ignored?
      end

      rule(:fragment_definition) do
        ignored? >> (
          str('fragment')                     >>
          fragment_name.as(:name)             >>
          str('on')                           >>
          type_condition.as(:type_condition)  >>
          directives.maybe.as(:directives)    >>
          selection_set.as(:selection_set)
        ).as(:fragment_definition) >> ignored?
      end

      rule(:fragment_name) do
        ignored? >> (str('on') >> ignored).absent? >> name.as(:name) >> ignored?
      end

      rule(:type_condition) do
        ignored? >> named_type >> ignored?
      end

      rule(:value) do
        ignored? >> (
          variable          |
          (
            float_value     |
            int_value       |
            string_value    |
            boolean_value   |
            enum_value      |
            list_value      |
            object_value
          ).as(:value)
        ) >> ignored?
      end

      rule(:value_const) do
        ignored? >> (
          float_value         |
          int_value           |
          string_value        |
          boolean_value       |
          enum_value          |
          list_value_const    |
          object_value_const
        ).as(:value) >> ignored?
      end

      rule(:boolean_value) do
        ignored? >> (
          str('true')   |
          str('false')
        ).as(:boolean_value) >> ignored?
      end

      rule(:enum_value) do
        ignored? >> (
          (
            str('true')   |
            str('false')  |
            str('null')
          ).absent? >> name
        ).as(:enum_value) >> ignored?
      end

      rule(:list_value) do
        ignored? >> (
          str('[')      >>
          value.repeat  >>
          str(']')
        ).as(:list_value) >> ignored?
      end

      rule(:list_value_const) do
        ignored? >> (
          str('[')            >>
          value_const.repeat  >>
          str(']')
        ).as(:list_value) >> ignored?
      end

      rule(:object_value) do
        ignored? >> (
          str('{')              >>
          object_field.repeat   >>
          str('}')
        ).as(:object_value) >> ignored?
      end

      rule(:object_value_const) do
        ignored? >> (
          str('{')                    >>
          object_field_const.repeat   >>
          str('}')
        ).as(:object_value) >> ignored?
      end

      rule(:object_field) do
        ignored? >> (
          name      >>
          str(':')  >>
          value
        ).as(:object_field) >> ignored?
       end

      rule(:object_field_const) do
        ignored? >> (
          name        >>
          str(':')    >>
          value_const
        ).as(:object_field) >> ignored?
      end

      rule(:variable_definitions) do
        ignored? >> str('(') >> variable_definition.repeat(1) >> str(')') >> ignored?
      end

      rule(:variable_definition) do
        ignored? >> (
          variable.as(:variable)                  >>
          str(':')                                >>
          type.as(:type)                          >>
          default_value.maybe.as(:default_value)
        ).as(:variable_definition) >> ignored?
      end

      rule(:variable) do
        ignored? >> (
          str('$') >> name
        ).as(:variable) >> ignored?
      end

      rule(:default_value) do
        ignored? >> str('=') >> value_const >> ignored?
      end

      rule(:type) do
        ignored? >> (non_null_type | list_type | named_type) >> ignored?
      end

      rule(:named_type) do
        ignored? >> name >> ignored?
      end

      rule(:list_type) do
        ignored? >> (
          str('[') >> type >> str(']')
        ).as(:list_type) >> ignored?
      end

      rule(:non_null_type) do
        ignored? >> (
          list_type >> str('!') | named_type >> str('!')
        ).as(:non_null_type) >> ignored?
      end

      rule(:directives) do
        ignored? >> directive.repeat(1) >> ignored?
      end

      rule(:directive) do
        ignored? >> (
          str('@') >> name.as(:name) >> arguments.maybe.as(:arguments)
        ).as(:directive) >> ignored?
      end

    end

  end
end
