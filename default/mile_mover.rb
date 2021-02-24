$graphical = false
require_relative "ur_robot"

    $world = RobotWorld.instance
    $world.place_beepers(13, 2, 1)


class MileMover < UrRobot    
    #Move 8 blocks = 1 robot world mile
    def move()
        super()
        super()
        super()
        super()
        super()
        super()
        super()
        super()
    end
end

def task()
    karel = MileMover.new(5, 2, NORTH, 0) 
    karel.move()
    karel.pick_beeper()
    karel.move()
    karel.put_beeper()
    karel.turn_off() 
    puts karel.to_s
end

task()
    $world.show_world_with_robots(1, 1, 25, 5)
