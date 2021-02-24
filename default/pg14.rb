#!/opt/local/bin/ruby

$graphical = false

require_relative "ur_robot"


$tracing = true

if $graphical
     screen = window(8, 40) # (size, speed)  
end

    $world = RobotWorld.instance
    $world.place_beepers(2,4, 1)
    
def task
    east = Robota::EAST
    karel = UrRobot.new(2, 2, east, 0, :blue)
    karel.move()
    karel.move()
    karel.pick_beeper()
    karel.move()
    karel.turn_left()
    karel.move()
    karel.move()
    karel.put_beeper()
    karel.move()
    karel.turn_off()
    $world.show_world_with_robots(1, 1, 6, 6)
    karel.display()
  
end

if __FILE__ == $0
  if $graphical
    screen.run do 
       task
    end
  else
    task()
  end
end
