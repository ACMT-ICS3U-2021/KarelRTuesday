
require_relative "beeper_layer"

# An interface to define strategies 
# Subclass this to define concrete strategies. 
class Strategy
    def do_it (robot)
        raise NotImplementedError.new("Unimplemented Strategy")
    end
end

# An implementation in which doIt does nothing at all
class NullStrategy < Strategy
    def do_it(robot)
        # nothing
    end
end

# Uses a strategy to determine how to put_beepers
class StrategyLayer < BeeperLayer

    # Initially does nothing when asked to put_beepers
    def initialize(street, avenue, direction, beepers, color = nil)
        super(street, avenue, direction, beepers, color)
        @strategy = NullStrategy.new()
    end
        
    # "Change the current strategy to any other
    def set_strategy(strategy)
        @strategy = strategy
    end
        
     # Delegate the action to the strategy
    def put_beepers()
        @strategy.do_it(self)
    end
end

# A strategy for putting two beepers on a corner
class TwoBeeperStrategy < Strategy
    def do_it(robot)
         robot.put_beeper()
         robot.put_beeper()
    end
end

def task()
    lisa = StrategyLayer.new(1, 3, EAST, INFINITY)
    lisa.set_strategy(TwoBeeperStrategy.new())
    lisa.lay_beepers()
end

if __FILE__ == $0
  screen = window(10, 80) # (size, speed)
  screen.run do
      task()
  end
end
