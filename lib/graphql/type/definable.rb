module GraphQL
  module Type

    module Definable

      def attr_definable(name, proc, strategy = :replace)
        @attr_definables ||= {} ; @attr_definables[name] = proc

        attr_reader name
        ivar_name = :"@#{name}"

        define_method(name) do |*args|
          unless args.length == 0
            next_value = args.first
            prev_value = instance_variable_get(ivar_name)

            raise GraphQL::Error::TypeError unless proc.call(next_value)

            next_value = case strategy
            when :concat then (prev_value || []).concat(next_value)
            when :merge then (prev_value || {}).merge(next_value)
            else next_value
            end

            instance_variable_set(ivar_name, next_value)
          end
          instance_variable_get(ivar_name)
        end
      end

      def attr_definables
        @attr_definables
      end

      def self.extended(base)
        base.send(:include, Validator)
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
