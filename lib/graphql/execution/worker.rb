require 'celluloid/current'

module GraphQL
  module Execution

    class Pool
      def self.future(&block)
        worker.future.perform(block)
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

      def self.worker
        Celluloid::Actor[worker_id] || Worker.supervise(as: worker_id)
        Celluloid::Actor[worker_id]
      end

      def self.worker_id
        @worker_id ||= SecureRandom.uuid
      end

    end

  end
end
