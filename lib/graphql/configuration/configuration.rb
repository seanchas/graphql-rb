require_relative 'slot'

module GraphQL
  module Configuration

    class Base

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
            slot.coerce.nil? ? args.first : slot.coerce.call(args.first)
          else
            slot.effective_type.new(*args, &block)
          end
        end

        private

        def define_accessors(slot)
          instance_variable_name      = :"@#{slot.name}"
          list_instance_variable_name = :"@#{slot.name}_list"

          if slot.list?
            define_method(:"#{slot.name}_list") do
              instance_variable_set(list_instance_variable_name, []) if instance_variable_get(list_instance_variable_name).nil?
              instance_variable_get(list_instance_variable_name)
            end
          end

          define_method(:"#{slot.name}=") do |*args, &block|
            if args.size > 0 || block_given?
              value = self.class.coerce(slot, *args, &block)

              raise RuntimeError.new "Cannot coerce." unless value.is_a?(slot.effective_type)

              if slot.list?
                public_send(:"#{slot.name}_list") << value
              else
                instance_variable_set(instance_variable_name, value)
              end
            end
            slot.list? ? nil : instance_variable_get(instance_variable_name)
          end

          alias_method :"#{slot.name}", :"#{slot.name}="
        end

      end

    end

  end
end
