#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

require_relative '../karel/robota'

# A mixin to add sensing capabilities to robots such as UrRobot. 
# Including this in a class will enable the robots to sense walls and 
# beepers, as well as other robots. A robot with these capabilities will 
# be able to test the direction it is facing. All of these methods
# return true or false. 
module SensorPack
  # Return true if the robot has any beepers in its beeper bag
  def any_beepers_in_beeper_bag?
    return @beepers == Robota::INFINITY || @beepers > 0
  end
  
  #Return true if the robot is on a corner with at least one beeper
  def next_to_a_beeper?
    return Robota::World.beepers_at?(@street, @avenue)
  end
  
  # Return true if the robot is facing North
  def facing_north?
    return @direction == Robota::NORTH
  end
  
 # Return true if the robot is facing West
   def facing_west?
    return @direction == Robota::WEST
  end
  
 # Return true if the robot is facing South
   def facing_south?
    return @direction == Robota::SOUTH
  end
  
 # Return true if the robot is facing East
   def facing_east?
    return @direction == Robota::EAST
  end
  
 # Return true if the robot is not facing a wall one half block away
   def front_is_clear?
   begin
     @direction.next_street(@street, @avenue)
     @direction.next_avenue(@street, @avenue)
   rescue FrontIsBlocked
     return false
   end
   return true
  end
  
 # Return true if the robot on a corner with at least one other robot
   def next_to_a_robot?
    return neighbors.length > 0
  end
end