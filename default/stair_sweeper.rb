
 $graphical = false
require_relative "ur_robot"

class StairSweeper < UrRobot    
    #Robot turns right by executing three turn_left instructions
    def turn_right()
        self.turn_left()
        self.turn_left()
        self.turn_left()
    end

    #Robot climbs one stair  
    def climb_stair()        
        self.turn_left()
        self.move()
        self.turn_right()
        self.move()
    end
end
        
def task()
    alex = StairSweeper.new(1, 1, EAST, 0)
    alex.climb_stair()
    alex.pick_beeper()
    alex.climb_stair()
    alex.pick_beeper()
    alex.climb_stair()
    alex.pick_beeper()
    alex.turn_off()
    alex.display()
end

    # $world = RobotWorld.instance
    # $world.read_world("../worlds/stair_world.txt")

# task()
# 
    # $world.show_world_with_robots