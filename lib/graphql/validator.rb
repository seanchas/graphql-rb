module GraphQL
  class Validator

    attr_reader :schema, :document, :variables, :errors

    RULES = {
      Language::Document => {
        Language::OperationDefinition => {
          Language::VariableDefinition => {
            Language::Variable => {
              rules: [
                :validate_default_values_are_correctly_typed,
                :validate_variables_are_input_types
              ]
            }
          }
        }
      }
    }

    def initialize(schema, document, variables)
      @schema     = schema
      @document   = document
      @variables  = variables
      @errors     = []
    end

    def validate!
      @errors = []
      visit(document, [], RULES)
      @errors.empty?
    end

    def visit(entry, stack, rules)
      return unless errors.empty?
      if entry.is_a?(Array)
        entry.each { |item| visit(item, stack, rules) }
      else
        stack.push(entry)
        if entry.is_a?(Struct)
          if rules && rules[entry.class] && rules[entry.class][:rules]
            rules[entry.class][:rules].each do |rule|
              return unless errors.empty?
              public_send(rule, stack)
            end
          end
          children_rules = rules[entry.class] rescue nil
          entry.members.each { |name| visit(entry[name], stack, children_rules) }
        end
        stack.pop
      end
    end

    # 5.6.1
    # Variables
    #

    # 5.6.1.1
    # Variable Default Values Are Correctly Typed
    #
    def validate_default_values_are_correctly_typed(stack)
    end

    # 5.6.1.2
    # Variable Default Values Are Correctly Typed
    #
    def validate_variables_are_input_types(stack)
    end

  end
end
