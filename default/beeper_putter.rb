
require_relative "ur_robot"



# Abstract class for beeper putting robots"
class BeeperPutter < UrRobot
    
    def distribute_beepers()
        raise NotImplementedError.new("Implemented in Subclasses")
    end
end


# A BeeperPutter that simply puts a beeper and moves"
class NoNeighbor < BeeperPutter
    
    def distribute_beepers()
        put_beeper()
        move()
    end
end

# A BeeperPutter that puts a robot and moves, but also asks its 
#  neighbor to do the same
class NeighborTalker < BeeperPutter

    def initialize(street, avenue, direction, beepers, neighbor)
         super(street, avenue, direction, beepers)
         @neighbor = neighbor
    end
         
    def distribute_beepers()
        put_beeper()
        move()
        @neighbor.distribute_beepers()
    end
end

def task()
    noname = NoNeighbor.new(1, 1, NORTH, 2)
    noname = NeighborTalker.new(1, 2, NORTH, 2, noname)
    noname = NeighborTalker.new(1, 3, NORTH, 2, noname)
    noname = NeighborTalker.new(1, 4, NORTH, 2, noname)
    noname.distribute_beepers()
end


if __FILE__ == $0
  screen = window(10, 80) # (size, speed)
  screen.run do
      task()
  end
end
