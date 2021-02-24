#!/opt/local/bin/ruby
#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

require_relative "run_params"
require_relative "stair_sweeper"
require_relative "robota"

# a task for a stair sweeper
def task()
  world = Robota::World
  world.read_world("../worlds/stair_world.txt")
  
  karel = StairSweeper.new(1, 1, EAST, 0, TRANSPARENT)
  karel.climb_stair()
  karel.pick_beeper()
  karel.climb_stair()
  karel.pick_beeper()
  karel.climb_stair()
  karel.pick_beeper()
  karel.turn_off()
  karel.display()
  world.show_world_with_robots(1, 1, 6, 6)
  karel.display()
  
end

if __FILE__ == $0
  if $graphical
     screen = window(8, 10) # (size, speed)
     screen.run do
       task()
     end
   else
     task()
   end
end