module GraphQL
  module Type

    class List

      attr_reader :of_type

      def initialize(of_type)
        raise GraphQL::Error::TypeError, "" unless GraphQL::Type.type?(of_type)
        @of_type = of_type
      end

      def to_s
        "[#{of_type.to_s}]"
      end

    end

  end
end
