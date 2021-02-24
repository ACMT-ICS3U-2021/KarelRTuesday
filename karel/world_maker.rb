#!/opt/local/bin/ruby

#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

$graphical = true
$world_maker_size = 12 if $world_maker_size == nil
# => require_relative 'tk'
require 'tkextlib/tcllib.rb'
require_relative 'robota'

=begin
  Each tool will drop the corresponding item at the mouse click location.
  Control click will remove an item if present (one beeper or a wall)
  Shift click will remove all beepers on the corner
  If there are no beepers on the corner then control click with the beeper tool places infinitely many there. 
=end
# A GUI to create and save world files 
class WorldMaker < TkFrame

 def initialize()
  super()
  @dirty = false
  $dialog = TkToplevel.new(self){
    title  ' World Creator '
  }
  $dialog.raise_window $window
  $world = Robota::World
  geometry_string = '200x' + '300' + "+900+25"
  $dialog.geometry(newGeometry = geometry_string)

  TkGrid.rowconfigure($dialog, 2, :weight => 1)
  TkGrid.columnconfigure($dialog, 0, :weight => 1)

  get_file = TkButton.new($dialog, :text => "Get File", :command => lambda{open_file})
  get_file.grid(:row => 0, :column => 0)
  @show_file = TkEntry.new($dialog, :state => :disabled)
  @show_file.grid(:row => 1, :column => 0, :sticky => "ew")
  put_file = TkButton.new($dialog, :text => "Save File", :command => lambda{save_file})
  put_file.grid(:row => 2, :column => 0, :sticky => 'n')
  @text = TkLabel.new($dialog, :text => "Tool")
  @text.grid(:row => 3, :column => 0)
  @beeper = TkButton.new($dialog, :text => "Beeper", :command => lambda{place_beeper}, :activeforeground => 'red')
  @beeper.grid(:row => 4, :column => 0)
  horizontal_wall = TkButton.new($dialog, :text => "EW Wall", :command => lambda{east_west_wall})
  horizontal_wall.grid(:row => 5, :column => 0)
  vertical_wall = TkButton.new($dialog, :text => "NS Wall", :command => lambda{north_south_wall})
  vertical_wall.grid(:row => 6, :column => 0)
  $instance = self
 rescue
  puts e.to_s
  puts e.backtrace
 end

  def dirty()
     @dirty = true
  end
  
  def check_dirty()
      if @dirty
         save_file()
         @dirty = false
         exit()
      end   
  end
  
  private
  def place_beeper
    # @beeper.flash
    @current_scaler = BeeperScaler.instance
    $window.cursor("dot")
    $window.canvas.bind("1", proc{|e| @current_scaler.drop_item(e.x, e.y)})
    $window.canvas.bind("Control-Button-1", proc{|e| @current_scaler.remove(e.x, e.y, false)})
    $window.canvas.bind("Shift-Button-1", proc{|e| @current_scaler.remove(e.x, e.y, true)})
    @text.configure(:text => "Beeper Tool")
    # puts 'beeper'
  end
  
  def east_west_wall
    # puts 'e w wall'
    @current_scaler = HorizontalWallScaler.instance
    $window.cursor("top_side")
    $window.canvas.bind("1", proc{|e| @current_scaler.drop_item(e.x, e.y)})
    $window.canvas.bind("Control-Button-1", proc{|e| @current_scaler.remove(e.x, e.y, true)})
    $window.canvas.bind("Shift-Button-1", proc{|e|}) #nothing
    @text.configure(:text => "EW Wall Tool")
  end
  
  def north_south_wall
    # puts 'n s wall'
    @current_scaler = VerticalWallScaler.instance
    $window.cursor("right_side")
    $window.canvas.bind("1", proc{|e| @current_scaler.drop_item(e.x, e.y)})
    $window.canvas.bind("Control-Button-1", proc{|e| @current_scaler.remove(e.x, e.y, true)})
    $window.canvas.bind("Shift-Button-1", proc{|e|})
    @text.configure(:text => "NS Wall Tool")
  end
  
 def open_file
    file =  Tk.getOpenFile
    if file
      $world.read_world(file)
      @show_file.configure(:state => :normal)
      @show_file.insert(0, file)
      @show_file.configure(:state => :disabled)
    end
  rescue Exception => e
  # puts e.to_s
  # puts e.backtrace
    puts "No file selected"
    end
  
  def save_file
    file = Tk.getSaveFile
    if file
      $world.save_world(file)
    # puts file
      # @show_file.configure(:state => :normal)
      # @show_file.delete(0, file.size + 1)
      # @show_file.configure(:state => :disabled)
      puts "file saved: " + file.to_s
      @dirty = false
    end
  rescue Exception => e
           # puts e.to_s
           # puts e.backtrace  
    puts "No file selected"
  end
  
  private

  class BeeperScaler
    
    @@instance = BeeperScaler.new
    
    def BeeperScaler.instance
      return @@instance
    end
    
    
    def scale(x, y)
      factor = $window.scale_factor
      factor = 1 if factor == 0
      return ((x - $inset + factor/2)/factor ).to_i, (($window_bottom - $inset - y + factor/2)/factor).to_i
    end
    
    def drop_item(x, y)
      canvas = $window.canvas    
      avenue, street = scale(x, y)  
      # puts street.to_s + ' ' + avenue.to_s
      if(street < 1 or avenue < 1 or street > $window.number_of_streets() or avenue > $window.number_of_streets()) 
        return
      end
      $world.place_beepers(street, avenue, 1)
      $instance.dirty()
    end
    
    def remove(x, y, all)
      canvas = $window.canvas    
      avenue, street = scale(x, y)  
      # puts street.to_s + ' ' + avenue.to_s
      if(street < 1 or avenue < 1 or street > $window.number_of_streets() or avenue > $window.number_of_streets()) 
        return
      end
      if all
        $world.remove_all_beepers(street, avenue)
        canvas.update
      else
        if $world.beepers_at?(street, avenue)
          $world.remove_beeper(street, avenue) 
        else
          $world.place_beepers(street, avenue, -1)
        end      
      end
      $instance.dirty()
    end
    
  end
    
  class HorizontalWallScaler
    
    @@instance = HorizontalWallScaler.new
    
    def HorizontalWallScaler.instance
      return @@instance
    end
    
    def scale(x, y)
      factor = $window.scale_factor
      factor = 1 if factor == 0
      return ((x - $inset + factor/2)/factor).to_i, (($window_bottom - $inset - y ) / factor).to_i
    end
    
    def drop_item(x, y)
      canvas = $window.canvas      
      avenue, street = scale(x, y)  
      if(street < 1 or avenue < 1 or street > $window.number_of_streets() or avenue > $window.number_of_streets()) 
        return
      end
     $world.place_wall_north_of(street, avenue)
      $instance.dirty()
    end

    def remove(x, y, all)
       canvas = $window.canvas      
      avenue, street = scale(x, y)  
      if(street < 1 or avenue < 1 or street > $window.number_of_streets() or avenue > $window.number_of_streets()) 
        return
      end
     $world.remove_wall_north_of(street, avenue)     
      $instance.dirty()
    end
  end

  class VerticalWallScaler
    
    @@instance = VerticalWallScaler.new
    
    def VerticalWallScaler.instance
      return @@instance
    end
    
    def scale(x, y)
      factor = $window.scale_factor
      factor = 1 if factor == 0
      return   ((x - $inset)/factor).to_i, (($window_bottom - $inset - y + factor/2) / factor).to_i
    end
    
    def drop_item(x, y)
      canvas = $window.canvas      
      avenue, street = scale(x, y)  
       if(street < 1 or avenue < 1 or street > $window.number_of_streets() or avenue > $window.number_of_streets()) 
        return
      end
     $world.place_wall_east_of(street, avenue)
      $instance.dirty()
    end

    def remove(x, y, all)
      canvas = $window.canvas      
      avenue, street = scale(x, y)  
       if(street < 1 or avenue < 1 or street > $window.number_of_streets() or avenue > $window.number_of_streets()) 
        return
      end
     $world.remove_wall_east_of(street, avenue)
      $instance.dirty()
    end
  end
   
end


# create the dialog and show it, along with a world
def task
   $maker = WorldMaker.new()
   class << $window # give the window a new closer
      def end_program(menu)
         $instance.check_dirty()
      end
   end
  
rescue Exception  => e
           puts e.to_s
           puts e.backtrace  
end

 if __FILE__ == $0
   $window = window($world_maker_size, 100)
   $window.run do
      task
   end
end