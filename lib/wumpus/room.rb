module Wumpus
  class Room
    def initialize(number)
      @number = number
      @hazards = {}
      @neighbors = {}
    end

    attr_reader :number, :neighbors

    def add(thing)
      @hazards[thing] = thing.to_s
    end

    def remove(thing)
      @hazards.delete(thing)
    end

    def has?(thing)
      @hazards.has_key?(thing)
    end

    def empty?
      @hazards.empty?
    end

    def safe?
      @neighbors.values.each do |neighbor|
        return false unless neighbor.empty?
      end

      self.empty?
    end

    def connect(other_room)
      @neighbors[other_room.number.to_s.to_sym] = other_room
      other_room.neighbors[@number.to_s.to_sym] = self
    end

    def exits
      exits = Array.new
      @neighbors.values.each do |neighbor|
        exits << neighbor.number
      end
      
      exits
    end

    def neighbor(number)
      @neighbors[number.to_s.to_sym]
    end

    def random_neighbor
      @neighbors[@neighbors.to_a.sample[0].to_sym]
    end
  end
end
