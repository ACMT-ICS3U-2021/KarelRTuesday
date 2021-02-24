#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

class RobotException < RuntimeError
  
  def initialize (message)
    super(message)
  end
end

# Raised if a robot tries to pick a beeper when none are present
class NoBeepers < RobotException
  def initialize (message)
    super("No Beepers on corner: " + message)
  end
 
end

# Raised when a Robot tries to move to an illegal corner
class IllegalCorner < RobotException
  def initialize (message)
    super("This corner is illegal: " + message)
  end
 
end

# Raised when a robot tries to communicate with a non-existant robot
class NoRobots < RobotException
  def initialize (message)
    super("No Robots on corner: " + message)
  end
 
end

# Raised if a robot tries to put a beeper when it has none in its beeper bag
class NoBeepersInBeeperBag < RobotException
  def initialize (message)
    super("No Beepers in BeeperBag: " + message)
  end
 
end

# Raised if a robot tries to execute an action when it is not running (predicates not affected)
class RobotNotRunning < RobotException
  def initialize (message)
    super("Robot is not running: " + message)
  end
 
end

# Raised if a robot tries to move through a wall
class FrontIsBlocked < RobotException
  def initialize (message)
    super("Front is blocked: " + message)
  end
 
end
