
require_relative "robot"
require_relative "turner"

# Interface for beeper putting robots"
class BeeperPutter < Robot
    include Turner
    
    def distribute_beepers()
        put_beeper()
        move()
    end

    def create_neighbor()
        raise NotImplementedError.new("Implemented in Subclasses")
    end
end

class NoNeighbor < BeeperPutter

    def create_neighbor()
        # Nothing
    end
  
end

class NeighborTalker < BeeperPutter

        def distribute_beepers()
        super()
        @neighbor.distribute_beepers()
    end

    def create_neighbor()
        move()
        if front_is_clear?()
            @neighbor = self.clone() # Create the copy 
            @neighbor.create_neighbor()
            for n in neighbors() do
              n.display
            end
       else 
            @neighbor = NoNeighbor.new(1, 1, WEST, 1)
            neighbors().each do |n|
              n.display
            end
            class << @neighbor
              def move
                super
                turn_left
              end
            end
            @neighbor.turn_right()
        end
        back_up()
        turn_right()
    end

end

def task()
    albert = NeighborTalker.new(1, 5, Robota::WEST, 1)
    albert.create_neighbor()
    albert.distribute_beepers()
end

if __FILE__ == $0
  screen = window(10, 80) # (size, speed)
  screen.run do
      task()
  end
end
