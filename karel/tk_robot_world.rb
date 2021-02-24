#Copyright 2010 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
#
# Replaces robot_world.rb with a graphical world based on tk. 

require_relative 'robota'
require_relative 'karel_window'
require 'monitor'

# $isVisible = false
$window = nil
$window_size = $window_bottom 
INFINITY = $INFINITY


# A graphical robot world based on tk graphics. Interacts with KarelWindow.
class RobotWorld < RobotWorldBase
  @@delay = 80
  @@instance = nil
  @@graphical_robots = {}

  private_class_method :new
 
  def initialize (name)
    super()
    # puts 'new tk robot world'
    @name = name
    @beepers = Hash.new(0)
    @east_west_walls = Hash.new(0)
    @north_south_walls = Hash.new(0)
    @robots = Hash.new(nil)

    @beepers.extend(MonitorMixin)
    @@beeper_control = @beepers.new_cond
   end
  
  def RobotWorld.instance()
    @@instance = new("Karel's World") unless @@instance
    @@instance
  end
  
  
  @@window_size = $window_size
  @@window = nil
  
  def update(robot, action, state)
    # sleep 0.5
    return unless state
    if action == MOVE_ACTION
      register_robot(robot, state)
      if $window
        sleep(@@delay / 100.0)
        $window.move_robot(@@graphical_robots[robot])
      end
    elsif action == CREATE_ACTION
       # puts 'create'
      register_robot(robot, state)
      if $window
           street, avenue, direction, color = state[0], state[1], state[2], state[5] #robot._street, robot._avenue robot._direction
           @@graphical_robots[robot] = $window.add_robot(street, avenue, direction, color)

      end
    elsif action == TURN_LEFT_ACTION
      # puts 'turn'
      if $window
        sleep(@@delay / 100.0)
        $window.turn_left_robot(@@graphical_robots[robot])
        # @@graphical_robots[robot].rotate()
      end
    elsif action == TURN_OFF_ACTION
       sleep(@@delay / 200.0)
      $window.turn_off_robot(@@graphical_robots[robot])
    elsif action == PICK_BEEPER_ACTION
      if $window
        @@graphical_robots[robot].pick_put()
      end
    elsif action == PUT_BEEPER_ACTION
      if $window
        @@graphical_robots[robot].pick_put()
      end
    else
      #nothing
    end
    @robots[robot] = state
    robot.display() if $tracing
  end
  
  def name
    @name
  end
  
  def RobotWorld.set_speed(amount)
    amount = 100 if amount > 100
    amount = 0 if amount < 0
    @@delay = 100 - amount
    $window.set_speed(amount)
  end
  
  # def speed_call_back(*args)
    # # if $window
      # # setDelay(100 - $window.iv.get())
    # # end
  # end
  
  def beepers_at?(street, avenue)
     (@beepers[[street, avenue]] != nil) and (@beepers[[street, avenue]] != 0)
  end
  
 def place_beepers(street, avenue, howMany=1, byRobot = false)
    @beepers.synchronize do
      if howMany == 0
        @@beeper_control.signal
        return
      end
      legal_corner(street, avenue)
      place = [street, avenue]
      sleep(@@delay / 400.0) if byRobot
      if howMany < 0
        @beepers[place] = INFINITY
        if window()
          $window.delete_beeper(place)
          $window.place_beeper(street, avenue, INFINITY)
        
        end
      @@beeper_control.signal
      return
      end
      inWorld = @beepers[place]
      toPlace = howMany + inWorld
      if window() and inWorld != INFINITY
        @beepers[place] = toPlace
        $window.delete_beeper(place) if inWorld > 0
        $window.place_beeper(street, avenue, toPlace)
      end
      @@beeper_control.signal
    end
  
  end
  
  def place_wall_north_of(street, avenue)
        # "Place an east-west wall segment north of this corner"
        legal_corner(street, avenue)
        @east_west_walls[[street, avenue]] = 1;        
        $window.place_wall_north_of(street, avenue) if $window
  end
  
  def remove_wall_north_of(street, avenue)
        legal_corner(street, avenue)
        @east_west_walls.delete([street, avenue])       
        $window.remove_wall_north_of(street, avenue) if $window
  end
  
  def place_wall_west_of(street, avenue)
        # "Place an north-south wall segment east of this corner"
        legal_corner(street, avenue)
        @north_south_walls[[street, avenue - 1]] = 1;
        $window.place_wall_east_of(street, avenue - 1) if $window
  end
  
  def place_wall_south_of(street, avenue)
        # "Place an east-west wall segment south of this corner"
        legal_corner(street, avenue)
        @east_west_walls[[street - 1, avenue]] = 1
        $window.place_wall_north_of(street - 1, avenue) if $window
  end
  
  def place_wall_east_of(street, avenue)
        # "Place an north-south wall segment east of this corner"
        legal_corner(street, avenue)
        @north_south_walls[[street, avenue]] = 1;
        $window.place_wall_east_of(street, avenue) if $window
  end
 
  def remove_wall_east_of(street, avenue)
         legal_corner(street, avenue)
        @north_south_walls.delete([street, avenue]);
        $window.remove_wall_east_of(street, avenue) if $window
  end
  
 
  # Return true if there is a wall to the North of the given corner
  def wall_to_north?(street, avenue)
    return @east_west_walls[[street, avenue]] > 0
  end
  
  # Return true if there is a wall to the West of the given corner
  def wall_to_west?(street, avenue)
    return (@north_south_walls[[street, avenue - 1]] > 0) || (avenue == 1)
  end
  
  # Return true if there is a wall to the South of the given corner
  def wall_to_south?(street, avenue)
    return (@east_west_walls[[street - 1, avenue]] > 0) || (street == 1)
  end
  
  # Return true if there is a wall to the East of the given corner
  def wall_to_east?(street, avenue)
    return @north_south_walls[[street, avenue]] > 0
  end
  
  def remove_all_beepers(street, avenue)
    @beepers.synchronize do
         place = [street, avenue]
        # howMany = @beepers[place]
        # if howMany != nil and howMany != 0  
          @beepers.delete(place)
          if $window 
             $window.delete_beeper(place)
          end
          @@beeper_control.signal
        # end
    end
  end
  
  def remove_beeper(street, avenue)
        # """Remove a single beeper from this corner. An exception will be raised if there are none"""
        @beepers.synchronize do
        sleep(@@delay / 200.0)
        place = [street, avenue]
        howMany = @beepers[place]
        if howMany > 0 
            howMany -= 1
            if howMany == 0 
                @beepers.delete(place)
                if $window 
                    $window.delete_beeper(place)
                end
            else
                @beepers[place] = howMany
                if $window
                    $window.delete_beeper(place)
                    $window.place_beeper(street, avenue, howMany)
                end
            end
        elsif howMany == INFINITY 
            @@beeper_control.signal
            return
        else 
           @@beeper_control.signal
             raise NoBeepers.new("(" + street.to_s + ", " + avenue.to_s + ")")
        end
        @@beeper_control.signal
        end
  end
  

# Return true if (x,y) is in the visible part of the world delimited by (xBound, yBound)
    def visible(x, y, xBound, yBound)
        return x >= 0 && y >= 0 && x < xBound && y < yBound
    end
  
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
       (avenuesTowardEast + 1).times do |j|
        display[2*i + 1]<< " . "
        display[2*i + 1]<< "   "
        display[2*i]<< "   "
        display[2*i]<< "   "
      end
    end
    #beepers
    @beepers.keys.each do |key|
      x, y = key[0], key[1]
      howMany = @beepers[key]
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
    yBound.times {|i| display[bottom][i] = "___"}  if bottom >= 0 and bottom < xBound 
    (xBound - 1).times {|i|  display[i+1][left-1] = display [i][left-1]= "|"} if left >= 1 and left < yBound 
    #eastwestwalls
    @east_west_walls.keys.each do |key|
      x, y = key[0], key[1]
      x = 2 * (x - startStreet) + 1
      y = 2 * (y - startAvenue)
      display[x + 1][y] = "___"  if  visible(x + 1, y, xBound, yBound) 
    end
    #northsouthwalls
    @north_south_walls.keys.each do |key|
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
        @robots.each_key do |robot|
            value = @robots[robot]
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
    @beepers.keys.each do |key|
       put_line(file, "beepers", key[0], key[1], @beepers[key])
    end
    @east_west_walls.keys.each{|key| 
      put_line(file, "eastwestwalls", key[0], key[1], key[1])
    }
    @north_south_walls.keys.each{|key|  
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

if ! $world
  $world = RobotWorld.instance() #RobotWorld.new("Karel's World")
end

def window (size = 12, speed = 100)
  if ! $window
    size = 10 if size <= 0
    $window = KarelWindow.new(size, size, $window_size)
    RobotWorld.set_speed(speed)
  end
  $window
end

def task
  #nothing
end

if __FILE__ == $0
  window().run(lambda { task})
end