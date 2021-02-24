
require_relative "ur_robot"
require_relative "strategy"
require_relative "turner"

# Maintains a strategy object that it will hand-off to a Spy
class Accomplice < UrRobot

    def initialize(street, avenue, direction, beepers, strategy)
        super(street, avenue, direction, beepers)
        @clue = strategy
    end
        
    # Give the strategy to whichever object asks for it -- a Spy 
    def request_clue()
  return @clue
    end
end

# Knows how to follow strategies given by accomplices
class Spy < UrRobot
    def initialize(street, avenue, direction, beepers, initial_strategy)
        super(street, avenue, direction, beepers)
        @strategy = initial_strategy
    end
    
    include Turner
        
    # Get the next part of the puzzle from the accomplice.
    # Must be on the same corner as the accomplice to get the strategy
    def get_next_clue()
        robot = neighbors().pop()
        @strategy = robot.request_clue()
    end
        
    # Follow the current strategy. Usually the one just obtained. 
    def follow_strategy()
        @strategy.do_it(self)
    end
end

class StartStrategy < Strategy
    def do_it(robot)
      robot.move()
      robot.move()
    end
end

# class LeftThenTwo < Strategy
    # def do_it(robot)
      # robot.turn_left()
      # robot.move()
      # robot.move()
    # end
# end

class RightThenThree < Strategy
    def do_it(robot)
      robot.turn_right()
      robot.move()
      robot.move()
      robot.move()
    end
end

class LeftTurnDecorator < Strategy
    def initialize(decorated) 
      @decorated = decorated
    end

    def do_it(robot)
        robot.turn_left()
        @decorated.do_it(robot)
    end
end



def task()
  start_strategy = StartStrategy.new()
  left_then_two = LeftTurnDecorator.new(start_strategy)
axl = Accomplice.new(1, 3, EAST, 0, left_then_two)
george = Accomplice.new(3, 3, EAST, 0, RightThenThree.new())
hari = Accomplice.new(3, 6, EAST, 0, left_then_two)
bernie = Spy.new(1, 1, EAST, 0, start_strategy)
bernie.follow_strategy()
bernie.get_next_clue() # from axl
bernie.follow_strategy()
bernie.get_next_clue() # from george
bernie.follow_strategy()
bernie.get_next_clue() # from hari
bernie.follow_strategy()

end

if __FILE__ == $0
  screen = window(10, 80) # (size, speed)
  screen.run do
      task()
  end
end


