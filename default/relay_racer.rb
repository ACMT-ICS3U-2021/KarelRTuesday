
require_relative "robot"
require_relative "turner"

class RelayRacer < Robot
    include  Turner
    def initialize(street, avenue,  direction, beepers) 
        super(street, avenue, direction, beepers)
        world = RobotWorld.instance()
        world.set_up_thread(self)
    end

    def run_task() 
        while not next_to_a_beeper?() 
            spin()
        end
        pick_beeper()
        run_to_robot()
        put_beeper()
        turn_off()
    end
     
    def spin() 
        turn_around()
        turn_around()
    end
          
    def run_to_robot() 
        move()
        while not next_to_a_robot?() 
            move()
        end
    end
end

def task()
    world = RobotWorld.instance()
    world.place_beepers(1, 1, 1)
    RelayRacer.new(1, 1, EAST, 0)
    RelayRacer.new(1, 5, EAST, 0)
    UrRobot.new(1, 10, NORTH, 0) ## to stop the race
    world.start_threads(1)

end

if __FILE__ == $0
  screen = window(10, 60) # (size, speed)
  screen.run do
      task()
  end
end
