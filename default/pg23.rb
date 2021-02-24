#!/opt/local/bin/ruby
$graphical = false

require_relative "ur_robot"


def task()
    world = RobotWorld.instance()
    world.place_beepers(3,1, 1)

    karel = UrRobot.new(3, 1, EAST, 0)
    carl = UrRobot.new(1, 1, EAST, 0)
    karel.pick_beeper()
    karel.turn_left()
    karel.turn_left()
    karel.turn_left()
    karel.move()
    karel.move()
    karel.put_beeper()
    carl.pick_beeper()
    carl.move()
    carl.move()
    carl.put_beeper()
    karel.turn_off()
    carl.turn_off()
    world.show_world_with_robots(1, 1, 6, 6)
    puts karel.display()
    puts carl.display()
end

task()
