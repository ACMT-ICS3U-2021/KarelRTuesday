
require_relative "robot"
require_relative "turner"

 class BeeperFinder < Robot
   include Turner
   
   # move to the beeper
   def find_beeper()
      while not next_to_a_beeper?()
         move_toward_beeper()
      end
   end

   # make one "step" of progress in moving toward beeper
   def move_toward_beeper()
      if front_is_clear?()
         move()
      else
         turn_left()
      end
   end

end

def task
  world = RobotWorld.instance()
  world.read_world("../worlds/fig6-8.kwld")
  world.place_beepers(5, 3, 1)
  world.remove_all_beepers(2, 5)
  jones = BeeperFinder.new(5, 2, SOUTH, 30)
  jones.find_beeper()
end

if __FILE__ == $0
  screen = window(12, 50) # (size, speed)
  screen.run do
      task()
  end
end

