require_relative 'slot'

module GraphQL
  module Configuration

    class Base

      def initialize(*args, &block)
        options = args.last.instance_of?(Hash) ? args.pop : {}
        slots.each { |key, slot| options[(slot.singular || slot.name).to_sym] = args.shift if args.size > 0 }
        options.each { |key, value| public_send(key, value) }
        instance_eval(&block) if block_given?
      end

      def slots
        self.class.slots
      end

      class << self
        def slots
          @slots ||= {}
        end

        def slot(*args, &block)
          slot = Slot.new(*args, &block)
          define_accessors(slot)
          slots[slot.name] = slot
        end

        def coerce(slot, *args, &block)
          if args.size == 1 && !block_given?
            value = args.first
            return value if value.is_a?(slot.effective_type)
            value = slot.coerce.nil? ? value : slot.coerce.call(value)
            return value if value.is_a?(slot.effective_type)
            return value if value.is_a?(Proc)
          end
          slot.effective_type.new(*args, &block)
        end

        private

        def define_accessors(slot)
          instance_variable_name  = :"@#{slot.name}"
          reader_name             = :"#{slot.name}"
          writer_name             = :"#{slot.name}="

          if slot.list?
            define_method(reader_name) do
              instance_variable_set(instance_variable_name, []) if instance_variable_get(instance_variable_name).nil?
              instance_variable_get(instance_variable_name)
            end

            instance_variable_name  = :"@#{slot.singular}"
            reader_name             = :"#{slot.singular}"
            writer_name             = :"#{slot.singular}="
          end

          define_method(writer_name) do |*args, &block|
            if args.size > 0 || block_given?
              value = self.class.coerce(slot, *args, &block)

              raise RuntimeError.new "Cannot coerce." unless value.is_a?(slot.effective_type) || value.is_a?(Proc)

              if slot.list?
                public_send(:"#{slot.name}") << value
              else
                instance_variable_set(instance_variable_name, value)
              end
            end
            slot.list? ? nil : instance_variable_get(instance_variable_name)
          end

          alias_method reader_name, writer_name
        end

      end

    end

  end
end
