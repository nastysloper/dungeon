class Dungeon
  attr_accessor :player

  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
  end

  def add_room(reference, name, description, connections)
    @rooms << Room.new(reference, name, description, connections)
  end

  def start(location)
    direction = ' '
    @player.location = location

    while true
      show_current_description
        puts "Which path do you take? (enter q or quit to exit)"
        print "> "
        direction = gets.chomp

        print "Connections are "
        show_connections(@player.location)

        while @player.connections.has_key?(direction.to_sym) == false
          puts "You stumble into a wall. Ow!"
        end

        if direction == 'quit' || direction == 'q'
          break
        end
      
        go(direction.to_sym) 
    end
  end

  def show_current_description
    # p "find room, player.location", find_room_in_dungeon(@player.location)
    # p find_room_in_dungeon(@player.location).full_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  def show_connections(current_room)
    puts 
  end

  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def go(direction)
    puts "\nYou go " + direction.to_s
    @player.location = find_room_in_direction(direction)
    #show_current_description
  end

  class Player
    attr_accessor :name, :location

    def initialize(name)
      @name = name
    end
  end

  class Room
    attr_accessor :reference, :name, :description, :connections

    def initialize(reference, name, description, connections)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
    end

    def full_description
      puts "~~" + @name + "~~" + "\nYou are in " + @description
      puts "You see a passageway to your ..."
      puts @connections.keys
    end

    def show_connections
      print @connections.keys
    end

  end

end

# Create the main dungeon object

my_dungeon = Dungeon.new("Rich Vogt")

# Add rooms to dungeon
my_dungeon.add_room(:entrance, "Dungeon entrance", "a forbidding and gloomy grotto. This is the entrance to the cave.",
                   {:left => :antechamber, :right => :large_cave})
my_dungeon.add_room(:large_cave, "Large Cave", "a large cave",
                   {:west => :entrance, :east => :low_tunnel})
my_dungeon.add_room(:antechamber, "Antechamber", "a wet, narrow passageway",
                   {:west => :entrance, :northeast => :corridor, :southeast => :pit})
my_dungeon.add_room(:medium_cave, "Medium Cave", "a medium-sized cave",
                   {:northwest => :corridor, :southwest => :pit, :south => :tunnel,
                    :southeast => :small_cave, :east => :echo_chamber})
my_dungeon.add_room(:small_cave, "Small Cave", "a small, damp cave",
                   {:northwest => :medium_cave, :southwest => :low_tunnel, :east => :echo_chamber})
my_dungeon.add_room(:low_tunnel, "Low Tunnel", "a spooky, claustrophobic crevice in the rock",
                   {:west => :large_cave, :north => :medium_cave, :northeast => :small_cave})
my_dungeon.add_room(:pit, "Pit", "a filthy, foul-smelling pit",
                   {:west => :antechamber, :northeast => :medium_cave})
my_dungeon.add_room(:echo_chamber, "Echo Chamber", "an unnerving, disorienting place",
                   {:northwest => :medium_cave, :west => :small_cave})
my_dungeon.add_room(:corridor, "Corridor", "a constricting crevice in the rock",
                   {:west => :antechamber, :east => :medium_cave})
# Start the game by placing the player in a room
my_dungeon.start(:entrance)
