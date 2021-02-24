#!/opt/local/bin/ruby

$graphical = false
$tracing = true

require_relative "ur_robot"

def task
       karel = UrRobot.new(1, 1, EAST, 0)
            # Deliver the robot to the origin (1,1),
            # facing east, with no beepers.
        # karel.set_pausing()
        $world.show_world_with_robots()
        karel.move()
        karel.move()
        karel.move()
        karel.pick_beeper()
        karel.turn_off()
        karel.display()
        $world.show_world_with_robots()
end

if $graphical
     screen = window(8, 40) # (size, speed)  
end
$world = RobotWorld.instance
$world.place_beepers(1,4, 1)

if $graphical
    screen.run do
      task
    end
else
    task()
end
