
require_relative "ur_robot"
require_relative "strategy"


class BlockWalker < UrRobot

    def initialize(street, avenue, direction, beepers) 
        super(street, avenue, direction, beepers)
        @strategy = ThreeBlockStrategy.new()
        @otherStrategy = TwoBlockStrategy.new()
    end

    def walk_a_side()
        @strategy.do_it(self)
        @strategy, @otherStrategy = 
          @otherStrategy, @strategy
    end

    class TwoBlockStrategy < Strategy
        def do_it(robot)
            robot.move()
            robot.move()
        end
    end
            
    class ThreeBlockStrategy < Strategy
        def do_it(robot)
            robot.move()
            robot.move()
            robot.move()
        end
    end
end

def task()
     john = BlockWalker.new(2, 2, EAST, 4)

     john.walk_a_side()
     john.put_beeper()
     john.turn_left()
     john.walk_a_side()
     john.put_beeper()
     john.turn_left()
     john.walk_a_side()
     john.put_beeper()
     john.turn_left()
     john.walk_a_side()
     john.put_beeper()
     john.turn_left()
end

if __FILE__ == $0
  screen = window(10, 80) # (size, speed)
  screen.run do
      task()
  end
end

