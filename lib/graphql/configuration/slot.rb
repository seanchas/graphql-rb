module GraphQL
  module Configuration

    class Slot

      def initialize(*args, &block)
        define_methods
        options = args.last.is_a?(Hash) ? args.pop : {}
        options.keys.each { |key| options[key.to_sym] = options.delete(key) }
        attributes.each { |name| options[name.to_sym] = args.shift if args.size > 0 }
        options.each { |key, value| public_send(key, value) }
        instance_eval(&block) if block_given?
        validate!
      end

      def list?
        type.is_a?(Array)
      end

      def effective_type
        @effective_type ||= begin
          t = list? ? type.first : type
          t = t.call if t.is_a?(Proc)
          t
        end
      end

      def errors
        @errors ||= {}
      end

      def valid?
        errors.size == 0
      end

      def validate
        @errors = {}
        attributes.each { |name| send(:"validate_#{name}") }
      end

      private

      def add_error(name, value)
        (errors[name.to_sym] ||= []) << value
      end

      def validate!
        validate
        raise StandardError.new("#{self.class.name} validation error: #{errors.keys} #{errors.inspect}") unless valid?
      end

      def validate_name
        add_error(:name, "missing") if @name.nil?
        add_error(:name, "should be a String or Symbold, got #{name}") unless @name.is_a?(String) or @name.is_a?(Symbol)
        add_error(:name, "cannot be empty") if @name.is_a?(String) && name.size == 0
      end

      def validate_type
        add_error(:type, "missing") if @type.nil?

        if type.instance_of?(Array)
          add_type_error unless @type.size == 1
          add_type_error unless type_valid?(@type.first)
        else
          add_type_error unless type_valid?(@type)
        end
      end

      def type_valid?(type)
        type.is_a?(Class) || type.is_a?(Module) || type.is_a?(Proc)
      end

      def add_type_error
        add_error(:type, "should be a Class, Module or Array of one Class or Module, got #{@type}")
      end

      def validate_coerce
        return if @coerce.nil?
        add_error(:coerce, "should be a Proc, got #{@coerce}") unless @coerce.is_a?(Proc)
      end

      def validate_description
        return if @description.nil?
        add_error(:description, "should be a String, got #{@description}") unless @description.is_a?(String)
      end

      def validate_null
        return if @null.nil?
        add_error(:null, "should be true or false, got #{@null}") unless !!@null == @null
      end

      def validate_singular
        @singular = :"#{@name}_item" if list? && @singular.nil?
        return if @singular.nil?
        add_error(:singular, "should be a String or Symbold, got #{@singular}") unless @singular.is_a?(String) or @singular.is_a?(Symbol)
      end

      def define_methods
        attributes.each do |key|
          instance_variable_name  = :"@#{key}"

          define_singleton_method(:"#{key}") do |*args|
            if args.size == 1
              public_send(:"#{key}=", args.first)
            else
              instance_variable_get(instance_variable_name)
            end
          end unless methods.include?(:"#{key}")

          define_singleton_method(:"#{key}=") do |value|
            instance_variable_set(instance_variable_name, value)
          end

        end
      end

      def attributes
        @attributes ||= [:name, :type, :coerce, :description, :null, :singular]
      end

    end

  end
end
