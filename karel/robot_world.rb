#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

require_relative "robota"

  NORTH = NorthDirection.instance
  WEST = WestDirection.instance
  SOUTH = SouthDirection.instance
  EAST = EastDirection.instance
  INFINITY = $INFINITY

# The simplest text based world in which the robots move and interact
# There is no graphics associated with this world. 
class RobotWorld < RobotWorldBase
  @@instance = nil

  private_class_method :new
  
  def initialize(name)
    super()
    clear
    @Robots = Hash.new(nil)
    @delay = 0.0

    @name = name
    @isVisible = false
  end
  
  def RobotWorld.instance()
    @@instance = new("Karel's World") unless @@instance
    @@instance
  end

  # Remove all features (walls, beepers) from the world.  Robots are not affected
  def clear
    @Beepers = Hash.new(0)
    @EastWestWalls = Hash.new(0)
    @NorthSouthWalls = Hash.new(0)
    @Runnables = []
  end
 
  # Return the name of this world
  def name
    @name
  end
  
  # Place a single beeper on a given corner
  def place_beeper(street, avenue)
    place_beepers(street, avenue, 1)   
    nil
  end
  
  # Place a given number of beepers on a given corner
  def place_beepers(street, avenue, howMany, byRobot = false)
    key = [street, avenue]
    if howMany == Robota::INFINITY || @Beepers[key] == Robota::INFINITY
      @Beepers[key] = Robota::INFINITY
    else
      @Beepers[key] += howMany   
    end
    nil
  end
  
  # Remove a single beeper from a given corner (if any are present)
  def remove_beeper(street, avenue)
    key = [street, avenue]   
    return if @Beepers[key] == Robota::INFINITY
    if @Beepers[key] > 0
      @Beepers[key] -= 1
    else
      raise NoBeepers, "(#{street}, #{avenue})"
    end
    nil
  end
  
  # Place a single wall segment North of a given corner, oriented East-West
  def place_wall_north_of(street, avenue)
    @EastWestWalls[[street, avenue]] = 1
    nil
  end
  
  # Place a single wall segment east of a given corner, oriented North-South
  def place_wall_east_of(street, avenue)
    @NorthSouthWalls[[street, avenue]] = 1
    nil
  end

  # Return true if there is a wall to the North of the given corner
  def wall_to_north?(street, avenue)
    return @EastWestWalls[[street, avenue]] > 0
  end
  
  # Return true if there is a wall to the West of the given corner
  def wall_to_west?(street, avenue)
    return (@NorthSouthWalls[[street, avenue - 1]] > 0) || (avenue == 1)
  end
  
  # Return true if there is a wall to the South of the given corner
  def wall_to_south?(street, avenue)
    return (@EastWestWalls[[street - 1, avenue]] > 0) || (street == 1)
  end
  
  # Return true if there is a wall to the East of the given corner
  def wall_to_east?(street, avenue)
    return @NorthSouthWalls[[street, avenue]] > 0
  end
  
  # def set_size(numberOfStreets = 10, numberOfAvenues = 10)
    # #TODO
  # end

  #        This two dimensional structure has the following properties. 
  #        Every other row and every other column is initially blank. Each cell is a three char string.
  #        Odd numbered rows are initially blank, Even numbered columns are initially blank.
  #        The first row will be imaged at the bottom of the output. The first column at the left.
  #        The blank rows and columns will eventually hold symbols for walls. 
  #        Only one symbol can appear in a cell. The entries for corners "." are added first with beepers
  #        next and finally robots. The last symbol added is the one shown when the display is printed. 
  #             
  def get_display(startStreet, startAvenue, streetsTowardNorth, avenuesTowardEast) 
    xBound = 2 * streetsTowardNorth + 1
    yBound = 2 * avenuesTowardEast + 1
    
    display = []
     (0 ..xBound).each do |i|
      display<<[] # a row
      display<<[] # a row
       (0..avenuesTowardEast + 1).each do |j|
        display[2*i + 1]<< " . "
        display[2*i + 1]<< "   "
        display[2*i]<< "   "
        display[2*i]<< "   "
      end
    end
    #beepers
    @Beepers.keys.each do |key|
      x, y = key[0], key[1]
      howMany = @Beepers[key]
      if howMany > 9 
        cell = " * "
      elsif howMany < 0 
        cell = "inf"
      elsif howMany > 0
        cell = " " + howMany.to_s + " "
      else
        cell = " . "
      end
      x = 2 * (x - startStreet) + 1
      y = 2 * (y - startAvenue)
      display[x][y] = cell if visible(x, y, xBound, yBound)
    end
    #boundary walls
    bottom = 2 * (1 - startStreet)
    left = 2 * (1 - startAvenue)
    if bottom >= 0 and bottom < xBound 
     (0..yBound).each {|i| display[bottom][i] = "___"}
    end
    if left >= 1 and left < yBound 
     (0..xBound - 1).each {|i|  display[i+1][left-1] = display [i][left-1]= "|"}
    end
    #eastwestwalls
    @EastWestWalls.keys.each do |key|
      x, y = key[0], key[1]
      x = 2 * (x - startStreet) + 1
      y = 2 * (y - startAvenue)
      display[x + 1][y] = "___"  if  visible(x + 1, y, xBound, yBound) 
    end
    #northsouthwalls
    @NorthSouthWalls.keys.each do |key|
      x, y = key[0], key[1]
      bottom = x
      x = 2 * (x - startStreet);
      y = 2 * (y - startAvenue) + 1;
      if visible(x + 1, y, xBound, yBound) 
        display[x + 1 ][y] = display[x][y] = " | "
        display[x][y] = "_|_" if bottom == 1 
      end
    end
    return display
  end
  
  #        Image the display with the first row at the bottom      
  def dump_display(display, startStreet, startAvenue,  streetsTowardNorth, avenuesTowardEast)
    lines = []
    i = 2 * streetsTowardNorth
    while i >= 0 
      if startAvenue == 1
        line = " |"
      else
        line = " "
      end
      for j in (0..2*avenuesTowardEast)
        line += display[i][j]
      end
      lines<<line
            i -= 1
        end
        lines<<""
        lines<< "Lower left corner is street: " + startStreet.to_s + " avenue: " + startAvenue.to_s + "."
        lines<<""
        lines.each{|aline| print aline + "\n"}
           
        nil
    end
    
    
#   Print a representation of the world (walls, corners, beepers) on std out
    def show_world(startStreet=1, startAvenue=1, streetsTowardNorth=10, avenuesTowardEast=10)
        display = get_display(startStreet, startAvenue, streetsTowardNorth, avenuesTowardEast)
        dump_display(display, startStreet, startAvenue, streetsTowardNorth, avenuesTowardEast)
        nil
    end    

#  Print a representation of the world including robots to std out. Robots will hide beepers and only
# one robot can be shown on a corner. 
   def show_world_with_robots(startStreet=1, startAvenue=1, streetsTowardNorth=10, avenuesTowardEast=10)
        display = get_display(startStreet, startAvenue, streetsTowardNorth, avenuesTowardEast)
        xBound = 2 * streetsTowardNorth + 1
        yBound = 2 * avenuesTowardEast + 1
        @Robots.keys().each do |robot|
            value = @Robots[robot]
            x, y, direction = value[0], value[1], value[2]
            x = 2 * (x - startStreet) + 1
            y = 2 * (y - startAvenue)
            displayCharacter = {Robota::NORTH => ' ^ ', Robota::WEST => ' < ', Robota::SOUTH => ' v ', Robota::EAST => ' > '}
            cell = displayCharacter[direction]
            display[x][y] = cell if visible(x, y, xBound, yBound)    
        end
        dump_display(display, startStreet, startAvenue, streetsTowardNorth, avenuesTowardEast)
        nil
    end

# Return true if (x,y) is in the visible part of the world delimited by (xBound, yBound)
    def visible(x, y, xBound, yBound)
        return x >= 0 && y >= 0 && x < xBound && y < yBound
    end

    private :dump_display, :get_display, :visible

  # Read a world from a text file with the given name
  def read_world(filename)
    File.open(filename) do |file| file.each_line do |line|
        if line != "KarelWorld"
          key, street, avenue, other = line.split
          street, avenue, other = street.to_i, avenue.to_i, other.to_i
          if key == "beepers"
            place_beepers(street, avenue, other)
          elsif key == "eastwestwalls"
            while avenue <= other
              place_wall_north_of(street, avenue)
              avenue += 1
            end
          elsif key == "northsouthwalls"
            street, avenue = avenue, street
            while street <= other
              place_wall_east_of(street, avenue)
              street += 1
            end
          end
        end
      end
    end
    nil
  end
  
  # Save (write) a world in a text file with a given name
  def save_world(filename)
    file = File.new(filename, "w")
    file.puts "KarelWorld"
    @Beepers.keys.each do |key|
       put_line(file, "beepers", key[0], key[1], @Beepers[key])
    end
    @EastWestWalls.keys.each{|key| 
      put_line(file, "eastwestwalls", key[0], key[1], key[1])
    }
    @NorthSouthWalls.keys.each{|key|  
      put_line(file, "northsouthwalls", key[1], key[0], key[0])
    }
    file.close
    nil
  end

  def put_line(file, key, a, b, c)
    file.puts "#{key} #{a} #{b} #{c}"
    nil
  end
   
  private  :put_line
   
end
