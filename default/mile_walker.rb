#!/opt/local/bin/ruby

$graphical = true
$tracing = true

require_relative "ur_robot"

if $graphical
     screen = window(85, 80) # (size, speed)  
end
     $world = RobotWorld.instance
     $world.place_beepers(3,82, 1)

# The class discussed around page 35 of the text. A class of robots that can
# move a mile (= 8 blocks) in one instruction
class MileWalker < UrRobot
    # move one mile (8 blocks)
    def move_mile
        move()
        move()
        move()
        move()
        move()
        move()
        move()
        move()
    end
end

# a sample task for a MileWalker
def task  
    lisa = MileWalker.new(3, 2, EAST, 0) 
      # Declare a new MileWalker lisa. 
    lisa.move_mile()
    lisa.move_mile()
    lisa.move_mile()
    lisa.move_mile()
    lisa.move_mile()
    lisa.move_mile()
    lisa.move_mile()
    lisa.move_mile()
    lisa.move_mile()
    lisa.move_mile()
    lisa.pick_beeper()
    lisa.turn_left()
    lisa.move_mile()
    lisa.move_mile()
    lisa.move_mile()
    lisa.move_mile()
    lisa.move_mile()
    lisa.turn_off()
    puts lisa.to_s
rescue Exception => e
  puts e.to_s
end

if __FILE__ == $0 
  if $graphical
    screen.run do 
      task()
    end
  else
    task
  end
end
