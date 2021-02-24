
require_relative "robot"

# Moves whenever the observed robot picks a beeper
# Note that these objects are both robots and observers (of robots). 
class WalkListener < UrRobot  # < Observer Ð implements update

    def initialize(street, avenue, direction, beepers, observed)
        super(street, avenue, direction, beepers)
        observed.add_observer(self)
    end
        
    # Message sent by the observed robot
    def update(robot, action, state)
        if action == PICK_BEEPER_ACTION 
            move()
        end
    end
end

def task()
    world = RobotWorld.instance()
    world.place_beepers(1, 1, 9)
    james = Robot.new(1, 1, EAST, 0)
    gloria = WalkListener.new(2, 1, EAST, 0, james)
    james.pick_beeper()
    james.pick_beeper()
    james.pick_beeper()
    james.pick_beeper()
    james.pick_beeper()
    james.move()
end

if __FILE__ == $0
  screen = window(10, 50) # (size, speed)
  screen.run do
      task()
  end
end
