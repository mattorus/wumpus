require "json"

module Wumpus
  class Cave

    attr_reader :rooms

    def self.dodecahedron
      self.from_json("./data/dodecahedron.json")
    end

    def self.from_json(filename)
      cave = Cave.new(12)
      json_file = File.open(filename)
      json_hash = JSON.load(json_file)
      json_hash.each do |pair|
        room = cave.rooms[pair[0].to_s.to_sym]
        if room.nil?
          room = Room.new(pair[0])
          cave.rooms[room.number.to_s.to_sym] = room
        end

        neighbor = cave.rooms[pair[1].to_s.to_sym]
        if neighbor.nil?
          neighbor = Room.new(pair[1])
          cave.rooms[neighbor.number.to_s.to_sym] = neighbor
        end

        room.connect(neighbor)
      end

      return cave
    end

    def initialize(edges)
      @rooms = {}
      @edges = edges
    end

    def add_hazard(thing, count)
      (1..count).each do |i|
        room = random_room
        redo if room.has?(thing)
        room.add(thing)
      end
    end

    def random_room
      random_room_number = @rooms.to_a.sample[0]
      room(random_room_number)
    end

    def move(thing, from: raise, to: raise) 
      from.remove(thing)
      to.add(thing)
    end

    def room_with(thing)
      room = random_room

      until room.has?(thing)
        room = random_room
      end

      return room
    end

    def entrance
      room = random_room

      until room.safe?
        room = random_room
      end

      return room
    end

    def room(number)
      @rooms[number.to_s.to_sym]
    end
  end
end
