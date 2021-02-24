
require_relative "ur_robot"

class RobotListener 
    def update()
        raise NotImplementedError.new("Listener update undefined")
    end
end

class NullListener < RobotListener
    def update() 
        # nothing
    end
end

class WalkListener < UrRobot # < RobotListener
    def update()   
        move()
    end
end

class ObservablePicker < UrRobot
    def initialize(street, avenue, direction, beepers)
        super(street, avenue, direction, beepers)
        @listener = NullListener.new()
    end


    def register(listener)  
        @listener = listener
    end
    

    def pick_beeper()
        super()
        @listener.update()
    end
end


def task()
  world = RobotWorld.instance()
  world.place_beepers(2, 3, 10)
tom = WalkListener.new(1, 1, NORTH, 0)
jerry = ObservablePicker.new(2, 3, EAST, 0)
jerry.register(tom)
  jerry.pick_beeper()
  jerry.pick_beeper()
  jerry.pick_beeper()
  jerry.pick_beeper()
  jerry.pick_beeper()
  jerry.pick_beeper()
  jerry.move()
  puts jerry.inspect()
end


if __FILE__ == $0
  screen = window(10, 50) # (size, speed)
  screen.run do
      task()
  end
end
