
require_relative "robot"

# Illustrates classic race conditions among threads.
class Racer < Robot

    def initialize(street, avenue, direction)
        super(street, avenue, direction, 0)
        world = RobotWorld.instance()
        world.set_up_thread(self)
    end
        
    # Race for the beeper
    def race()
        while not next_to_a_beeper?() 
            move()
        end
        pick_beeper()
        turn_off()
    end


    # Runs the race in its own thread
    def run_task()
        race()
        display
    end
end

def task()
    world = RobotWorld.instance()
    world.place_beepers(1, 1, 1)
    
    alex = Racer.new(100, 1, SOUTH)
    jose = Racer.new(1, 100, WEST)    
    world.start_threads(10)
end

if __FILE__ == $0
  screen = window(100, 98) # (size, speed)
  screen.run do
      task()
  end
end
