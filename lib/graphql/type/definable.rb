module GraphQL
  module Type

    module Definable

      def attr_definable(name, proc)
        attr_reader name

        define_method(name) do |*args|
          unless args.length == 0
            next_value = args.first
            raise GraphQL::Error::Type unless proc.call(next_value)
            prev_value = instance_variable_get(:"@#{name}")
            next_value = case prev_value
            when Array  then prev_value.concat(next_value)
            when Hash   then prev_value.merge(next_value)
            else next_value
            end
            instance_variable_set(:"@#{name}", next_value)
          end
          instance_variable_get(:"@#{name}")
        end
      end

    end

  end
end
