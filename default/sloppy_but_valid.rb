#!/opt/local/bin/ruby

$graphical = true

require_relative "ur_robot"

def task
karel = UrRobot.new 1, 1, EAST, 0
   karel.move()
            karel.move()
       karel.move()
                        karel.pick_beeper(); karel.turn_off()
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
