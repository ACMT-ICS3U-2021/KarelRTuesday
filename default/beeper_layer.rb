
require_relative 'ur_robot'
# Abstract class to lay a row of beepers 
class BeeperLayer < UrRobot  
    # Puts beepers on four corners as defined by a subclass
    def lay_beepers()
        move()
        put_beepers()
        move()
        put_beepers()
        move()
        put_beepers()
        move()
        put_beepers()        
        move()
        turn_off()
    end
end

#Puts two beepers on each corner when asked to lay_beepers"
class TwoRowLayer < BeeperLayer
    def put_beepers()
        put_beeper()
        put_beeper()
    end
end


#Puts three beepers on each corner when asked to lay_beepers"
class ThreeRowLayer < BeeperLayer
    def put_beepers()
        put_beeper()
        put_beeper()
        put_beeper()
    end
end

def task()
    lisa = TwoRowLayer.new(1, 3, EAST, INFINITY)
    lisa.lay_beepers()
    lisa = ThreeRowLayer.new(2, 3, EAST, INFINITY)
    lisa.lay_beepers()
    lisa = TwoRowLayer.new(3, 3, EAST, INFINITY)
    lisa.lay_beepers()
    lisa = ThreeRowLayer.new(4, 3, EAST, INFINITY)
    lisa.lay_beepers()
    lisa = TwoRowLayer.new(5, 3, EAST, INFINITY)
    lisa.lay_beepers()
end

if __FILE__ == $0
  screen = window(10, 80) # (size, speed)
  screen.run do
      task()
  end
end
