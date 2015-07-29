module GraphQL
  module Type

    module Definable

      def attr_definable(*args)
        attr_reader *args

        args.each do |arg|
          define_method(arg) do |*args|
            instance_variable_set(:"@#{arg}", args.first) unless args.length == 0
            instance_variable_get(:"@#{arg}")
          end
        end
      end

    end

  end
end
