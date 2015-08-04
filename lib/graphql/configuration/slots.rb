require_relative 'slot'

module GraphQL
  module Configuration

    class Slots

      def initialize(&block)
        instance_eval(&block) if block_given?
      end

      def slots
        @slots ||= {}
      end

      def slot(*args, &block)
        slot = Slot.new(*args, &block)

        define_accessor(slot)

        slots[slot.name] = slot
      end

      private

      def define_collection_accessor(slot)

      end

      def define_accessor(slot)
        instance_variable_name = :"@#{slot.name}"

        define_singleton_method(:"#{slot.name}") do |*args, &block|
          if args.size > 0 || block_given?
            public_send(:"#{slot.name}=", *args, &block)
          else
            instance_variable_get(instance_variable_name)
          end
        end

        define_singleton_method(:"#{slot.name}=") do |*args, &block|
          if args.size == 1 && !block_given?
            value = slot.coerce(args.first)
            puts value.inspect
            instance_variable_set(instance_variable_name, value) if value.is_a?(slot.type)
          end
          instance_variable_get(instance_variable_name)
        end
      end

    end

  end
end
