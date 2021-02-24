#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

require_relative "robot_world_base"

# Direction in the robot world (North, West, South, East)
# This is an abstract class
class Direction
  protected :initialize
  #Create a direction and name it
  def initialize(name)
    @name = name
  end
  
  def to_s
    @name
  end
   
  # the next direction counter-clockwise from self
  def next
    return Robota.next_direction(self)
  end
  
  # The next street in the direction faced (if facing North or South)
  # The street the robot will be on if it moves in this direction
  def next_street(street, avenue)
    street
  end
  
  # The next avenue in the direction faced (if facing East or West)
  # The avenue the robot will be on if it moves in this direction
  def next_avenue(street, avenue)
    avenue
  end
  
end

# Represents the North direction. Knows how to calculate the next counter-clockwise direction and how to 
# compute the next street and avenue in this direction. It defines a singleton via the instance method.
class NorthDirection < Direction
@@instance = nil
  private_class_method :new  # Create the North direction
  def initialize
    super("North")
  end
  
  # The next street in the direction faced (if facing North or South)
  # The street the robot will be on if it moves in this direction
  def next_street(street, avenue)
    if Robota::World.wall_to_north?(street, avenue)
      raise FrontIsBlocked,  "moving North at (" + street.to_s + ", " + avenue.to_s + ")"
    end
    street + 1
  end
  
  def NorthDirection.instance
    @@instance = new unless @@instance
    @@instance
  end
  
end

# Represents the South direction. Knows how to calculate the next counter-clockwise direction and how to 
# compute the next street and avenue in this direction. It defines a singleton via the instance method.
class SouthDirection < Direction
@@instance = nil
  private_class_method :new

  # Create the South direction
  def initialize
    super("South")
  end
  
  # The next street in the direction faced (if facing North or South)
  # The street the robot will be on if it moves in this direction
  def next_street(street, avenue)
    if Robota::World.wall_to_south?(street, avenue)
      raise FrontIsBlocked,  "moving South at (" + street.to_s + ", " + avenue.to_s + ")"
    end
    street - 1
  end

  def SouthDirection.instance
    @@instance = new unless @@instance
    @@instance
  end

end

# Represents the East direction. Knows how to calculate the next counter-clockwise direction and how to 
# compute the next street and avenue in this direction. It defines a singleton via the instance method.
class EastDirection < Direction
@@instance = nil
  private_class_method :new
  
  # Create the East direction
  def initialize
    super("East")
  end
  
  # The next avenue in the direction faced (if facing East or West)
  # The avenue the robot will be on if it moves in this direction
  def next_avenue(street, avenue)
     if Robota::World.wall_to_east?(street, avenue)
      raise FrontIsBlocked,  "moving East at (" + street.to_s + ", " + avenue.to_s + ")"
    end
   avenue + 1
  end

  def EastDirection.instance
    @@instance = new unless @@instance
    @@instance
  end
  
end

# Represents the West direction. Knows how to calculate the next counter-clockwise direction and how to 
# compute the next street and avenue in this direction. It defines a singleton via the instance method.
class WestDirection < Direction
@@instance = nil
  private_class_method :new
  
  # Create the West direction
  def initialize
    super("West")
  end
  
  # The next avenue in the direction faced (if facing East or West)
  # The avenue the robot will be on if it moves in this direction
  def next_avenue(street, avenue)
    if Robota::World.wall_to_west?(street, avenue)
       raise FrontIsBlocked,  "moving West at (" + street.to_s + ", " + avenue.to_s + ")"
    end
    avenue - 1
  end

  def WestDirection.instance
    @@instance = new unless @@instance
    @@instance
  end
  
end