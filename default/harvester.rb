require_relative "ur_robot"


class Harvester < UrRobot
    # Before executing this, the robot should be facing East,
    # on the first beeper of the current row.  
    def harvest_two_rows()
        harvest_one_row()
        go_to_next_row()
        harvest_one_row()
    end
    
    # Before executing this, the robot should be facing West,
    # on the last corner of the current row.
    def position_for_next_harvest()
        turn_right()
        move()
        turn_right()
    end
    
    private
    
    def turn_right()
        turn_left()
        turn_left()
        turn_left()
    end
        
    def harvest_one_row()
         harvest_corner()
         move()
         harvest_corner()
         move()
         harvest_corner()
         move()
         harvest_corner()
         move()
         harvest_corner()
    end
    
    def harvest_corner()
         pick_beeper()
    end
        
    # Before executing this, the robot should be facing East,
    # on the last corner of the current row. 
    def go_to_next_row()
         turn_left()
         move()
         turn_left()
    end
end

def task()
    world = RobotWorld.instance
    world.read_world("../worlds/fig3-2.kwld")
    world.show_world_with_robots()
    mark =  Harvester.new(2, 2, EAST, 0)
    mark.move()
    mark.harvest_two_rows()
    mark.position_for_next_harvest()
    mark.harvest_two_rows()
    mark.position_for_next_harvest()
    mark.harvest_two_rows()
    mark.move()
    mark.turn_off()
    world.show_world_with_robots()
end

if __FILE__ == $0
  screen = window(10, 80) # (size, speed)
  screen.run do
      task()
  end
end
