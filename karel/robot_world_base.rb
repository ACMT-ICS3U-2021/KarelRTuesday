#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

require_relative "robota"
require_relative "robot_exception"

# The the basic features of a world in which the robots move and interact. Other worlds extend this one, 
# such as RobotWorld (in robot_world.rb) and RobotWorld (in tk_robot_world.rb)
class RobotWorldBase
  attr_reader :Beepers, :EastWestWalls, :NorthSouthWalls
  public :Beepers, :EastWestWalls, :NorthSouthWalls
  
  MOVE_ACTION = 0
  TURN_LEFT_ACTION = 1
  PICK_BEEPER_ACTION = 2
  PUT_BEEPER_ACTION = 3
  TURN_OFF_ACTION = 4
  CREATE_ACTION = 5
  NO_ACTION = -1
  
  
 # Create an empty world
 def initialize
   clear
   @Robots = Hash.new(nil)
   @delay = 0.0
 end
 
 # Remove all features (walls, beepers) from the world.  Robots are not affected
 def clear
    @Beepers = Hash.new(0)
    @EastWestWalls = Hash.new(0)
    @NorthSouthWalls = Hash.new(0)
   @Runnables = []
 end
  
  # Assert that the given corner is in the world
  def legal_corner(street, avenue)
    raise IllegalCorner "(#{street}, #{avenue})" if street < 1 || avenue < 1
  end
  
  # Remove all features (walls, beepers, robots) from the world. 
  def reset
    clear
    @Robots = Hash.new(nil)    
  end
  
  # Save the new state of a robot when necessary
  def register_robot(robot, state)
    @Robots[robot] = state
    nil
  end
    
  # pause all of the robots for one step - requiring each to be restarted with a return enterd in console. 
  def pause_all()
    @robots.keys.each do |robot|
      robot.one_pause()
    end
  end
  
  # Record a robot's actions 
  def update(robot, action, state)
    return if action == NO_ACTION 
    if action == MOVE_ACTION || action == CREATE_ACTION 
      register_robot(robot, state)   
    end
    robot.display() if $tracing
    sleep @delay if @delay > 0
  end
  
  # Set the speed at which the simulation runs 0 = no delay 100 = run very slowly  
  def set_speed (amount)
    amount = 100 - amount
    amount = 0 if amount < 0
    amount = 100 if amount > 100
    @delay = amount / 100.0
  end
  
  # Either (a) pass a number of robots each of which has a run_task method or
  #        (b) pass a block to be executed when the thread starts
  def set_up_thread(*robots, &action)
    if block_given?
      @Runnables.push( Thread.new{Thread.stop; action.call})
    else
      robots.each {|robot| @Runnables.push Thread.new {Thread.stop; robot.run_task}}
    end
    # if $graphical
      # window().show_pause(self)
    # end
  end
  
  # def is_a_thread?(thread)
    # return @Runnables.include?(thread)
  # end
  
  # Start all of the known threads and wait until they all complete
  def start_threads(delay = 10)
    delay = 1 if delay <= 0
    sleep(delay / 10.0)
    @Runnables.each{|thread| thread.wakeup}
     @Runnables.each{|thread| thread.join}
  end
  
  # def pauseall()
    # @Runnables.length do 
      # if @Runnables.include?(Thread.current)
        # Thread.sleep  
      # end
    # end
  # end
  
  # def un_pause_threads()
      # $thread_monitor.broadcast()
#       
        # # @Runnables.list.each {|thread| 
        # # thread.exit
      # # }
   # end
  
  # Return true if there are any beepers on the given corner
  def beepers_at?(street, avenue)
    key = [street, avenue]
    return @Beepers[key] != 0
  end
  
  # Return true if there are any robots on the given corner
  def robots_at?(street, avenue)
    @Robots.keys.each do |robot|
      state = @Robots[robot]
      return true if street == state[0] && avenue == state[1]
    end
    return false
  end
  
  # Fail if there are no robots on the given corner
  def assert_robots_at(street, avenue)
    raise NoRobots, "(#{street}, #{avenue})" if ! robots_at?(street, avenue)
  end
  
  # Fail if there are no robots on the given corner
  def assert_beepers_at(street, avenue)
    raise NoBeepers, "(#{street}, #{avenue})" if  ! beepers_at?(street, avenue)
  end
   
  # Return the neighbors of the given robot on the given street.
  # Fails if the robot is not on the given corner when invoked
  def neighbors_of(robot, street, avenue)
    result = []
    robot.assert_at(street, avenue)
    @Robots.keys.each do |anyRobot|
      state = @Robots[anyRobot]
      x, y = state[0], state[1]
      result << anyRobot if anyRobot != robot && x == street && y == avenue
    end
    return result
  end
  
end