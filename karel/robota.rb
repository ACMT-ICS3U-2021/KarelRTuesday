#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

require_relative "direction"
require_relative "../mixins/assertions"

$INFINITY = -1

$graphical = true if $graphical == nil 
if $graphical
 require_relative 'tk_robot_world' # enable this line for a graphical world
else
  require_relative "robot_world" # enable this line for a text world
end

MOVE_ACTION = RobotWorldBase::MOVE_ACTION
TURN_LEFT_ACTION = RobotWorldBase::TURN_LEFT_ACTION
PICK_BEEPER_ACTION = RobotWorldBase::PICK_BEEPER_ACTION
PUT_BEEPER_ACTION = RobotWorldBase::PUT_BEEPER_ACTION
TURN_OFF_ACTION = RobotWorldBase::TURN_OFF_ACTION
CREATE_ACTION = RobotWorldBase::CREATE_ACTION
NO_ACTION = RobotWorldBase::NO_ACTION


# A general framework in which robots of various kinds may be defined. It does not, however, define
# any instantiable robots. The actions of robots are declared, but not defined here. Also defined is
# an assertion API that the programmer may use to make assertions about the state of a robot. 
# the requires (above) determine whether the world is graphical or text based. 
class Robota
  
  # Place a robot at a given corner (street, avenue) facing a given direction, with an initial
  # number of beepers in its beeper bag
  def initialize(street, avenue, direction, beepers)
    World.legal_corner(street, avenue)
    @street = street
    @avenue = avenue
    beepers = INFINITY if beepers < 0
    @beepers = beepers
    @direction = direction
    @ID = @@nextId
    @@nextId += 1
  end
  
  @@nextId = 0 
  
  
  NORTH = NorthDirection.instance
  WEST = WestDirection.instance
  SOUTH = SouthDirection.instance
  EAST = EastDirection.instance
  INFINITY = $INFINITY
  
 
  World = RobotWorld.instance() 
  
  NextDirection = {NORTH => WEST, WEST => SOUTH, SOUTH => EAST, EAST => NORTH}
  
  # Move one block in the current direction (provided the front is clear)
  def move
    raise "Implemented in sub-class."
  end
  
  # Turn 90 degrees to the left from the current direction
  def turn_left
    raise "Implemented in sub-class."
  end
  
  # Pick a beeper from the current corner (provided there is one to pick)
  def pick_beeper
    raise "Implemented in sub-class."
  end
  
  # Put a beeper on the current corner (provided the robot has one in the beeper bag)
  def put_beeper
    raise "Implemented in sub-class."
  end
  
  # Turn off, making further actions impossible
  def turn_off
    raise "Implemented in sub-class."
  end
  
  # def >
    # move
  # end
#   
  # def ^
    # pick_beeper
  # end
#   
  # def v 
    # put_beeper
  # end
#   
  # def <
    # turn_left
  # end
  
  # Implement this as the robot task in a subclass for use with the thread subsystem
  def run_task
    #Nothing
  end
  
  # Return true if this robot is running. 
  def running?
    return false
  end

  # Return a string representation of the state of this robot. 
  def to_s
    if running?
      running = ", running"
    else
      running = ", not running"
    end
    howMany = @beepers
    a_color = ""
    if @color != nil
      a_color = @color.capitalize()
    end
    howMany = "infinitely many" if howMany == INFINITY
    return a_color.to_s + " #{self.class} with ID #@ID at (#@street, #@avenue) facing #@direction with " + howMany.to_s + " beepers" + running
  end
  
  # Show the state of this robot on standard output (the console).
  def display()
    puts inspect
  end
  
  # Return the next counter-clockwise direction from the one specified
  def Robota.next_direction(direction)
    NextDirection[direction]
  end
  
  include Assertions
  
end