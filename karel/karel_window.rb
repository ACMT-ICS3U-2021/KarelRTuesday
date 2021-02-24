#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

require "tk"
require_relative 'robota'
require "monitor"

NORTH = NorthDirection.instance
WEST = WestDirection.instance
SOUTH = SouthDirection.instance
EAST = EastDirection.instance
  
$triangle_beepers = false if $triangle_beepers == nil

$inset = 30 
$window_bottom = 800 if $window_bottom == nil
if $small_window
  $window_bottom = 600
end
$moveParameters = {NORTH => [0, -1], WEST => [-1, 0], SOUTH => [0, 1], EAST => [1, 0] }
$directions = [NORTH, WEST, SOUTH, EAST]
$imageMapOn = {}
$imageMapOff = {}

$images_base = "../karel/images/" if $images_base == nil

class RobotImage

 # Create a screen image of a robot
 def initialize(street = 1, avenue = 1, direction = NORTH, color = nil, window = nil)
    @street = street
    @avenue = avenue
    @direction = direction
    @canvas = window.canvas
    @color = color

    if ! $smallImages
      @@size = 37
      @@backset = @@size/2 #18
    end
    @scaler = lambda{|x,y| window.scale_to_pixels(x,y)} #i.e. the function itself
    @scale_factor = lambda{window.scale_factor}
    color = :white if @color == nil
    @imageMap = {}
    $imageMapOn.each_key{|dir|
      @imageMap[dir] = TkLabel.new(@canvas, :bg => color, :image => $imageMapOn[dir], :width => @@size, :height => @@size, :borderwidth => 0)
    }
    @image = @imageMap[direction]

    @imageMap.inspect
    mx, my = scaler(street, avenue)
    
    @image.place(:x => mx, :y => my)  
  end
  
  $smallImages = true
  @@size = 25 #25 #37 
  @@backset = @@size/2 #12 #12 # 18
  @bg_color = :white
  
  def scaler (x, y)
    x, y = @scaler.yield(x,y)
    [x - @@backset, y - @@backset]
  end

  def scale_factor
    @scale_factor.yield()
  end

  # Remove the robot image from the screen
  def delete_all
    @image.place_forget 
  end

  # def move_scale
    # #TODO
  # end
  
  def greyOut
     delete_all
     color = @color
     if @color == nil
       color = :white
     end
     @image = TkLabel.new(@canvas,:bg => color, :image => $imageMapOff[@direction], :width => @@size, :height => @@size, :borderwidth => 0)
  end
  
  def move(amount = 1)
     dx, dy = $moveParameters[@direction]
     @street -= dy*amount
     @avenue += dx*amount
     x, y = scaler(@street, @avenue)
     if @canvas
       @canvas.update
       @image.place(:x => x , :y => y)
       if @color == nil
         @bg_color = :white
         if $world.beepers_at?(@street, @avenue)
           @bg_color = :black
         end
           @image.configure(:bg => @bg_color)
       end
     end
  end
  
  def rotate
    @direction = $directions[($directions.index(@direction) + 1) %4]
    delete_all 
    @image = @imageMap[@direction]
     x, y = scaler(@street, @avenue)
     if @canvas
       @image.place(:x => x , :y => y)
       if @color == nil
         @bg_color = :white
         if $world.beepers_at?(@street, @avenue)
           @bg_color = :black
         end
           @image.configure(:bg => @bg_color)
       end
     end    
  end
  
  def pick_put()
       if @color == nil
         @bg_color = :white
         if $world.beepers_at?(@street, @avenue)
           @bg_color = :black
         end
           @image.configure(:bg => @bg_color)
       end
  end
  
end # of RobotImage class

# Graphical representation of the robot world
class KarelWindow < TkFrame
  @@Beepers = {}
  @@delay = 20
  # @@showing_pause = false
  # @@threads_paused = true
  $beeper_color = :black if $beeper_color == nil
  $street_color = :red if $street_color == nil
  $wall_color = :black if $wall_color == nil
  
  def cursor(which) # use "dot" or "X_cursor" or "right_side" or "top_side"
  begin
    @canvas.cursor which # Set a new cursor while the passed block executes
    @canvas.update # Make sure it updates  the screen
  end
end

  def number_of_streets
    @_streets
  end
  
    # Terminate the program and close the window. 
    def end_program(menu)
       exit()
    end

  def initialize(streets, avenues, size = $window_bottom)
    super()
    
    @root = TkRoot.new{
        title  ' Karel\'s World '
        width size + 60
        height size
        background :white
    }

    $smallImages = streets > 9
    $window_bottom = size
    @height = size
    geometryString = ($window_bottom + 80).to_s + 'x' + ($window_bottom + 65).to_s + "+55+25" # 820 + 60 for the speed buttons
    @root.geometry(newGeometry = geometryString)
    
    bar = TkMenu.new
    
    def save(menu)
      file = Tk.getSaveFile
      if file
        $world.save_world(file)
        puts "file saved: " + file.to_s
      end
      rescue Exception => e
        puts "No file selected"
    end
    
    def pause(menu)
      $world.pause_all()
    end
        
    def toggle_trace(menu)
      if $tracing == nil
        $tracing = false
      end
      $tracing = ! $tracing
    end
           
        fil = TkMenu.new(:font => 'Monaco')
        fil.add_command(:label => 'Pause All     ^P', :command => lambda { pause('Pause Robots')})
        fil.add_command(:label => 'Toggle Trace  ^T', :command => lambda { toggle_trace('Toggle Trace')})
        fil.add_command(:label => 'Save World    ^S', :command => lambda { save('Save World')})
        fil.add_command(:label => 'Quit          ^Q', :command => lambda { end_program('Quit')})
        bar.add_cascade(:label => :Karel, :menu => fil)
        @root.configure(:menu =>  bar)   
        
        bind_all('Command-q'){end_program('Command-q')} # Mac standard
        bind_all('Control-q'){end_program('Control-q')} # Windows
        bind_all('Command-s'){save('Command-s')} # Mac standard
        bind_all('Control-s'){save('Control-s')} # Windows
        bind_all('Command-p'){pause('Command-p')} # Mac standard
        bind_all('Control-p'){pause('Control-p')} # Windows
        bind_all('Command-t'){toggle_trace('Command-t')} # Mac standard
        bind_all('Control-t'){toggle_trace('Control-t')} # Windows
        bind_all('Destroy'){end_program('Window Closed')}
        
        @_streets = streets
        @_avenues = streets # sic Avenues ignored
        @_gBeepers = {} #locations of the beeper imagess
        @_contents = [] # , walls, beepers that need to move on a rescale
        @_robots = []
        @_walls = [] 
        top = winfo_toplevel()
        TkGrid.rowconfigure(top, 2, :weight => 1)
        TkGrid.columnconfigure(top, 0, :weight => 1)
        
        TkGrid.rowconfigure(self, 2, :weight => 1)
        TkGrid.columnconfigure(self, 0, :weight => 1)
        
        
        TkGrid.rowconfigure(@root, 2, :weight => 1)
        TkGrid.columnconfigure(@root, 0, :weight => 1)
        
        @speedLevel = TkLabel.new(:text => "Speed " + (100-@@delay).to_s)
        @speedLevel.grid(:row => 0, :column => 0, :sticky=>"news")

        slower = TkButton.new(:text => "Slower", :command => lambda{
          @@delay = 1 if @@delay == 0
          @@delay = [(@@delay + 0.10*@@delay).ceil, 100].min
          RobotWorld.set_speed 100 - @@delay
          })
        slower.grid(:row => 0, :column => 1)
        
        faster = TkButton.new(:text => "Faster", :command => lambda{
          @@delay = [(@@delay - 0.10*@@delay).floor, 0].max
          RobotWorld.set_speed 100 - @@delay
           })
        faster.grid(:row => 1, :column => 1)
        
        @height = @oldHeight = $window_bottom
        @_bottom = $window_bottom - $inset
        @_left = $inset
        @_top = $inset
        @_right = @height
        @inset = $inset
        
        @canvas = Canvas.new(root, :height => $window_bottom, :width => $window_bottom, :bg => 'white')
      
        @canvas.grid(:row => 2, :column => 0, :sticky=>"news")
      if $smallImages  
        image1 = TkPhotoImage.new(:file => $images_base+'kareln.gif')
        image2 = TkPhotoImage.new(:file => $images_base+'karelw.gif')
        image3 = TkPhotoImage.new(:file => $images_base+'karels.gif')
        image4 = TkPhotoImage.new(:file => $images_base+'karele.gif')
        
        image5 = TkPhotoImage.new(:file => $images_base+'karelnOff.gif')
        image6 = TkPhotoImage.new(:file => $images_base+'karelwOff.gif')
        image7 = TkPhotoImage.new(:file => $images_base+'karelsOff.gif')
        image8 = TkPhotoImage.new(:file => $images_base+'kareleOff.gif')
      else # large images
        image1 = TkPhotoImage.new(:file => $images_base+'karelnLn.gif')
        image2 = TkPhotoImage.new(:file => $images_base+'karelwLn.gif')
        image3 = TkPhotoImage.new(:file => $images_base+'karelsLn.gif')
        image4 = TkPhotoImage.new(:file => $images_base+'kareleLn.gif')
        
        image5 = TkPhotoImage.new(:file => $images_base+'karelnOffLn.gif')
        image6 = TkPhotoImage.new(:file => $images_base+'karelwOffLn.gif')
        image7 = TkPhotoImage.new(:file => $images_base+'karelsOffLn.gif')
        image8 = TkPhotoImage.new(:file => $images_base+'kareleOffLn.gif')
      end         
        $imageMapOn[NORTH] = image1 #knOn
        $imageMapOn[WEST] = image2 #kwOn
        $imageMapOn[SOUTH] = image3 #ksOn
        $imageMapOn[EAST] = image4 #$keOn
        
        $imageMapOff[NORTH] = image5 #knOff
        $imageMapOff[WEST] = image6 #kwOff
        $imageMapOff[SOUTH] = image7 #ksOff
        $imageMapOff[EAST] = image8 #keOff
        
        geometry(@height)
        set_size(streets)

  end
  
  def canvas
    @canvas
  end
  
  def set_size(streets)
    @_streets = streets
    @_walls.each do  |wall|
      @canvas.delete(wall)
    end
    make_streets_and_avenues
    make_boundary_walls
    label_streets_avenues
    (@_contents + @_robots).each do |item|
      item.move_scale
    end
  end
  
  def make_streets_and_avenues
    @_streets.times do |i|
      x,y = scale_to_pixels(i + 1, 0.5)
      tx,ty = scale_to_pixels(i + 1, @_streets + 0.5)
      @_walls << TkcLine.new(@canvas,x,y,tx,ty, :fill => $street_color)
      x, y = scale_to_pixels(0.5, i + 1)
      tx, ty = scale_to_pixels(@_streets + 0.5, i + 1)
      @_walls << TkcLine.new(@canvas,x,y,tx,ty, :fill => $street_color)
    end
  end
  
  def make_boundary_walls
    x, y = scale_to_pixels(0.5, 0.5)
    @_walls << TkcLine.new(@canvas, x, 0, x, y, :width => 2)
    @_walls << TkcLine.new(@canvas, x, y, @_right + $inset, y, :width => 2)
    if $closed_world
       (@_streets - 1).times do |street|
          $world.place_wall_east_of(street + 1 , @_avenues - 1)
          $world.place_wall_north_of(@_streets - 1, street + 1)
          place_wall_east_of(street + 1 , @_avenues - 1)
          place_wall_north_of(@_streets - 1, street + 1)
       end
    end
  end
  
  def label_streets_avenues
    @_streets.times do |i|
      x, y = scale_to_pixels(i + 1, 0.25)
      @_walls << TkcText.new(@canvas, x, y, :fill => :black, :text => (i+1).to_s)
      x, y = scale_to_pixels(0.25, i + 1)
      @_walls << TkcText.new(@canvas, x, y, :fill => :black, :text => (i+1).to_s)
    end
  end
  
   def clear
     (@_contents + @_robots).each{|item|
       item.delete_all()}
   end
  
   def geometry(height)
        @oldHeight = @height
        @height = height
        @_bottom = height - $inset
        @_left = $inset
        @_top = $inset
        @_right = height
    end
    
    def scale_factor
      geometry(@height)
      (@_bottom - @_top)*1.0/@_streets
    end
    
    def scale_to_pixels(street, avenue)
       scale = scale_factor()
       [@_left + avenue*scale, @_bottom - street*scale]
     end
     
     def place_beeper(street,avenue, number)
       # puts 'placing ' + number.to_s + ' at ' + street.to_s + ' ' + avenue.to_s
       beeper = Beeper.new(street, avenue, number, self)
       beeper.place
       @@Beepers [[street, avenue]] = beeper
     end
     
     def delete_beeper(beeperLocation) # removes ALL beepers at this location
       # sleep 0.5
       beeper = @@Beepers[beeperLocation]
       if beeper
         beeper.delete_all
         @@Beepers.delete(beeperLocation)
         @_contents.delete(beeper)
       end
     end
     
     def place_wall_north_of(street, avenue)
       @_contents << Wall.new(street, avenue, false, self)
     end
     
     def place_wall_east_of(street, avenue)
       @_contents << Wall.new(street, avenue, true, self)
     end
     
     def remove_wall_north_of(street, avenue)
       @_contents.each { |x| 
       if x.class == Wall and x.street == street and x.avenue == avenue and not x.vertical?
         x.delete_all
         @_contents.delete x
       end
       }
     end
     
     def remove_wall_east_of(street, avenue)
     @_contents.each { |x| 
       if x.class == Wall and x.street == street and x.avenue == avenue and x.vertical?
         x.delete_all
         @_contents.delete x
       end
       }
     end
     
     def add_robot(street, avenue, direction, color)
       robot = RobotImage.new(street, avenue, direction, color, self)
       @_robots << robot
       robot
     end
     
     def turn_off_robot(robot)
       # robot.delete_all
       robot.greyOut
       robot.move(0)
     end
     
     def move_robot (robot, amount = -1)
       amount = 1 unless amount > 1
        # robot.delete_all
       robot.move(amount)
     end
     
     def turn_left_robot(robot)
       # robot.delete_all
       robot.rotate       
     end
     
    def set_speed (amount)
      @@delay = 100 - amount
      @speedLevel.text("Speed " + amount.to_s)
    end

  class Beeper
    @@bNumber = 0
       def initialize(street, avenue, number, window)
            @street = street
            @avenue = avenue
            @number = number
            @scaler = lambda{|x,y| window.scale_to_pixels(x,y)} #i.e. the function itself
            @scale_factor = lambda{window.scale_factor}
            @canvas = window.canvas
            @tag = "b" + @@bNumber.to_s
            @@bNumber += 1
        end
        
        def scaler (x, y)
          @scaler.yield(x,y) 
        end
        
        def scale_factor
          @scale_factor.yield()
        end
            
        def place()
            sizeFactor = 0.6 #Change this to change beeper size. The others scale from it. 
            placeFactor = 0.5 * sizeFactor
            val = @number.to_s
            val = 'N' if @number < 0
            # len = val.length()
            x,y = scaler(@street+placeFactor, @avenue-placeFactor)
            # $triangle_beepers = false
  
         if $triangle_beepers   
            where = []
            where << scaler(@street+sizeFactor, @avenue)
            where << scaler(@street-placeFactor, @avenue-placeFactor)
            where << scaler(@street-placeFactor, @avenue+placeFactor)
            oval = TkcPolygon.new(@canvas, where, :fill => $beeper_color, :smooth => false, :tags=>@tag)
         else
            oval = TkcOval.new(@canvas, x, y, x + scale_factor*sizeFactor, y + scale_factor*sizeFactor, :fill=> $beeper_color, :tags => @tag)
         end
            TkcText.new(oval, x + scale_factor*placeFactor,  y + scale_factor*placeFactor,
                   :tags => @tag, :width => 0, :text =>val, :fill => :white)
        end

        def move_scale
          @canvas.delete(@tag)
          place
        end
        
        def delete_all
            @canvas.delete(@tag)
        end
    
  end # of Beeper class
  
 class Wall
    attr_reader :street, :avenue
   
    def initialize(street, avenue, isVertical, window)
      @street = street
      @avenue = avenue
      
      
      @isVertical = isVertical
      @canvas = window.canvas
      @scaler = lambda{|x,y| window.scale_to_pixels(x,y)} #i.e. the function itself
      @scale_factor = lambda{window.scale_factor}
      if@isVertical
        x, y = scaler(street - 0.5, avenue + 0.5)
        @code = TkcLine.new(@canvas, x, y, x, y - scale_factor, :width => 2, :fill => $wall_color)
      else 
        x, y = scaler(street + 0.5, avenue - 0.5)
        @code = TkcLine.new(@canvas, x, y, x + scale_factor, y, :width => 2, :fill => $wall_color)
      end
    end
    
    
    def vertical?
      @isVertical
    end

        def scaler (x, y)
          @scaler.yield(x,y) 
        end
        
        def scale_factor
          @scale_factor.yield()
        end
            
    def delete_all
      @canvas.delete(@code)
    end

    def move_scale
      @canvas.delete(@code)
      if@isVertical
        x, y = scaler(street - 0.5, avenue + 0.5)
        @code = TkcLine.new(@canvas, x, y, x, y - scale_factor, :width => 2, :fill => :black)
      else
        x, y = scaler(street + 0.5, avenue - 0.5)
        @code = TkcLine.new(@canvas, x, y, x + scale_factor, y, :width => 2, :fill => :black)
      end
    end
    
  end # of Wall class
  
 def run (*task, &block)
    if block_given?
      mainThread = Thread.new do begin
       block.call  #thread this??
      rescue Exception => e
          puts e.to_s
          puts e.backtrace
        end
      end
    else
      mainThread = Thread.new do begin
        task()
        rescue Exception => e
           puts e.to_s
           puts e.backtrace
        end
      end
    end
    mainloop
  end
  
  
end # of KarelWindow

if __FILE__ == $0
   window = KarelWindow.new(streets = 12, avenues = 12)
   window.mainloop
end