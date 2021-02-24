
require_relative "robot"
require_relative "turner"

class Racer < Robot 
    include Turner
    
    def race()
      8.times do
        race_stride()
      end
    end
    
    def race_stride() 
        pick_beeper if next_to_a_beeper?()
        if front_is_clear?() 
            move()
        else 
            jump_hurdle()
        end
    end       

private 

    def jump_hurdle() 
        jump_up()
        move()
        glide_down()
    end

    def jump_up() 
        turn_left()
        move()
        turn_right()
    end

    def glide_down()  
        turn_right()
        move()
        turn_left()
    end
end # of Racer

def task()
  world = RobotWorld.instance()
  world.place_beepers(1, 1, 1)
  world.place_beepers(1, 5, 1)
  world.place_beepers(1, 7, 1)
  world.read_world("../worlds/fig5-2.kwld")
  kendal = Racer.new(1, 1, EAST, 0)
  kendal.race()
end

if __FILE__ == $0
  screen = window(10, 50) # (size, speed)
  screen.run do
      task()
  end
end

