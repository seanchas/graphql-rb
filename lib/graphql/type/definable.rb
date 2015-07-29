module GraphQL
  module Type

    module Definable

      def attr_definable(name, proc)
        @attr_definables ||= {} ; @attr_definables[name] = proc

        attr_reader name

        define_method(name) do |*args|
          unless args.length == 0
            next_value = args.first
            raise GraphQL::Error::TypeError unless proc.call(next_value)
            instance_variable_set(:"@#{name}", next_value)
          end
          instance_variable_get(:"@#{name}")
        end
      end

      def attr_definables
        @attr_definables
      end

      def self.extended(base)
        base.public_send(:include, Validator)
      end

      module Validator

        def valid?
          self.class.attr_definables.all? do |name, proc|
            proc.call(public_send(name))
          end
        end

      end

    end

  end
end
