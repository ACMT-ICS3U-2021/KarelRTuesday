
require_relative "robot"
require_relative "turner"

class Guard < Robot
    include Turner

    def move_to_southeast_corner()     
        face_south()
        follow_edge() # Now at south edge of field
        turn_left()
        follow_edge() # Now at south-east corner of field
        turn_left() # Now at south-east corner facing North
    end

    def walk_perimeter()  # Robot begins at a corner of the field
        4.times do 
            follow_edge()
            turn_left()
        end
    end
    
    def follow_edge()
        while next_to_a_beeper?() 
            if front_is_clear?() 
                move()
            else 
                pick_beeper()
            end
        end
        if not front_is_clear?() 
            if any_beepers_in_beeper_bag?() 
                put_beeper()
            else 
                back_up()
            end
        else 
            back_up()
        end
    end

    def face_south()
        while not facing_south?() 
            turn_left()
        end
    end
    
    def guard_field()
      move_to_southeast_corner()
      walk_perimeter()
    end

end

def task()
   world = RobotWorld.instance()
   world.read_world("../worlds/fig6-15.kwld")
   karel = Guard.new(5, 5, EAST, 0)
   karel.guard_field()
  
end

if __FILE__ == $0
    screen = window(10, 80)
    screen.run do
        task()
    end
end
