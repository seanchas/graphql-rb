require 'celluloid/current'
require 'logger'

module StarWars
  class Data
    include Celluloid

    Human   = Struct.new('Human', :id, :name, :friends, :appears_in, :home_planet)
    Droid   = Struct.new('Droid', :id, :name, :friends, :appears_in, :primary_function)

    Luke    = Human.new('1000', 'Like Skywalker',   ['1002', '1003', '2000', '2001'],   [4, 5, 6], 'Tatooine')
    Vader   = Human.new('1001', 'Darth Vader',      ['1004'],                           [4, 5, 6], 'Tatooine')
    Han     = Human.new('1002', 'Han Solo',         ['1000', '1003', '2001'],           [4, 5, 6])
    Leia    = Human.new('1003', 'Lea Organa',       ['1000', '1002', '2000', '2001'],   [4, 5, 6], 'Alderaan')
    Tarkin  = Human.new('1004', 'Wilhuff Tarkin',   ['1001'],                           [4])

    ThreePO = Droid.new('2000', 'C-3PO',            ['1000', '1002', '1003', '2001'],   [4, 5, 6], 'Protocol')
    Artoo   = Droid.new('2001', 'R2-D2',            ['1000', '1002', '1003'],           [4, 5, 6], 'Astromech')

    Characters = [Luke, Vader, Han, Leia, Tarkin, ThreePO, Artoo]

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def self.get(id)
      Fetcher.fetch(id)
    end

    def self.select(ids)
      Fetcher.fetch(ids)
    end


    class Fetcher
      include Celluloid

      def self.logger
        @logger ||= Logger.new(STDOUT)
      end

      def self.fetch(id_or_ids)
        logger.info "Fetching `#{id_or_ids}`"
        pool.future.fetch(id_or_ids)
      end

      def self.pool
        @pool ||= new
      end

      def initialize
        @timer  = after(0.01) { perform_fetch }
        @data   = {}
      end

      def restart
        @timer.reset
      end

      def fetch(id_or_ids)
        condition = Celluloid::Condition.new
        (@data[id_or_ids] ||= []) << lambda { |value| condition.signal(value) }
        restart
        condition.wait
      end

      def perform_fetch
        self.class.logger.info "Performing fetch"
        data        = @data
        @data       = {}
        ids         = data.keys.flatten.uniq
        self.class.logger.info "select * from table where id in #{ids}"
        # sleep 1
        characters  = Data::Characters.select { |c| ids.include?(c.id) }
        data.each do |key, blocks|
          result = if key.is_a?(Array)
            result = characters.select { |c| key.include?(c.id) }
          else
            result = characters.find { |c| key == (c.id) }
          end
          blocks.each { |block| block.call(result) }
        end
      end

    end


  end
end
