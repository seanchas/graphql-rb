require 'celluloid/current'

module GraphQL
  module Execution

    class Pool
      def self.future(&block)
        _pool.future.perform(block)
      end

      protected

      class Worker
        include Celluloid

        def perform(block)
          value = block.call
          value = value.value if value.is_a?(Celluloid::Future)
          value
        end
      end

      def self._pool
        Celluloid::Actor[pool_id] || Worker.supervise(as: pool_id)
        Celluloid::Actor[pool_id]
      end

      def self.pool_id
        @pool_id ||= SecureRandom.uuid
      end

    end

  end
end
