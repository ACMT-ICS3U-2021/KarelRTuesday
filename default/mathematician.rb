
require_relative "robot"
require_relative "turner"

class Mathematician < Robot
  include Turner
  
    def face_west()
      while not facing_west?()
        turn_left
      end
    end
  
    def face_south()
      while not facing_south?()
        turn_left
      end
    end
    
    def face_east()
      while not facing_east?()
        turn_left
      end
    end
    
    def face_north()
      while not facing_north?()
        turn_left
      end
    end
    
    def walk_to_wall()
      if front_is_clear?()
        move()
        walk_to_wall()
      end
    end
    
    def go_to_origin()
      face_west()
      walk_to_wall()
      face_south()
      walk_to_wall()
    end
  
    def advance_to_next_diagonal()
        if facing_west?() 
            face_north()
        else 
            face_east()
        end
        move()
        turn_around()
    end

    def zig_left_up()
        #Precondition: facing_west? and front_is_clear?
        #Postcondition facing_west?
        move()
        turn_right()
        move()
        turn_left()
    end
        
    def zag_down_right()
        #Precondition facing_south? and front_is_clear?
        #Postcondition facing_south?
        move()
        turn_left()
        move()
        turn_right()
    end

    def zig_move()
        #Precondition facing_west?
        if front_is_clear?() 
            zig_left_up()
        else 
            advance_to_next_diagonal()
        end
    end

    def zag_move()
        #Precondition facing_south?
        if front_is_clear?() 
            zag_down_right()
        else 
            advance_to_next_diagonal()
        end
    end
    
    def find_beeper()
        go_to_origin()
        face_west()
        while not next_to_a_beeper?() 
            if facing_west?() 
                zig_move()
            else 
                zag_move()
            end
        end
    end
  
end

def task()
   world = RobotWorld.instance()
   world.place_beepers(3, 4, 1)
   karel = Mathematician.new(3, 3, EAST, 0)
   karel.find_beeper()
end

if __FILE__ == $0
  screen = window(10, 80) # (size, speed)
  screen.run do
      task()
  end
end
