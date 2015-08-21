require 'celluloid/current'

module GraphQL
  module Execution

    class Pool
      def self.future(&block)
        pool.future.perform(block)
      end

      protected

      class Worker
        include Celluloid

        def perform(block)
          value = block.call
          value = value.value if value.is_a?(Celluloid::Future)
          value
        rescue Exception => e
          e
        end
      end

      def self.pool
        Celluloid::Actor[pool_id] ||= Worker.pool
      end

      def self.pool_id
        @pool_id ||= SecureRandom.uuid
      end

    end

  end
end
