#!/opt/local/bin/ruby

#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

$graphical = true

require_relative 'ur_robot'
require 'tk'

# a class whose objects are dialogs that control a simple robot. 
class RemoteControl < TkFrame
  @@count = 0

  def initialize (name, street, avenue, direction, beepers, color=TRANSPARENT)
    super()
    @robot = UrRobot.new(street, avenue, direction, beepers, color)
    @name = name
    color = :white if color == nil
    @dialog = TkToplevel.new(self){
      title  name
      bg color
    }
    @@offset = 15
    $canvas = $window.canvas
    @dialog.raise_window $window
    $world = Robota::World
    where = "+" + (900 + @@count*@@offset).to_s + "+" + (25 + @@count*@@offset).to_s
    geometry_string = '150x' + '170' + where #"+900+25"
    @@count += 1
    @dialog.geometry(newGeometry = geometry_string)

    TkGrid.rowconfigure(@dialog, 2, :weight => 1)
    TkGrid.columnconfigure(@dialog, 0, :weight => 1)

    move = TkButton.new(@dialog, text: "Move", command: lambda{move_robot})
    move.grid(:row => 0, :column => 0)
    turn = TkButton.new(@dialog, text: "TurnLeft", command: lambda{turn_robot})
    turn.grid(:row => 1, :column => 0, :sticky => 'n')
    pick = TkButton.new(@dialog, text: "PickBeeper", command: lambda{pick_beeper})
    pick.grid(:row => 2, :column => 0, :sticky => 'n')
    put = TkButton.new(@dialog, text: "PutBeeper", command: lambda{put_beeper})
    put.grid(:row => 3, :column => 0, :sticky => 'n')
    off = TkButton.new(@dialog, text: "TurnOff", command: lambda{off_robot})
    off.grid(:row => 4, :column => 0, :sticky => 'n')
    put_file = TkButton.new(@dialog, text: "Save File", command: lambda{save_file})
    put_file.grid(:row => 5, :column => 0, :sticky => 'n')
  end

  private

    def move_robot
      @robot.move
      puts @name + ' moved.'
      $canvas.update
    rescue Exception  => e
             puts e.to_s
             puts e.backtrace  
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
      end
    rescue Exception => e
             # puts e.to_s
             # puts e.backtrace  
      puts "No file selected"
    end


    def turn_robot
      @robot.turn_left
      puts @name + ' turned left.'
      $canvas.update
    rescue Exception  => e
             puts e.to_s
             puts e.backtrace  
    end

    def pick_beeper
      @robot.pick_beeper
      puts @name + ' picked one beeper.'
      $canvas.update
    rescue Exception  => e
             puts e.to_s
             puts e.backtrace  
    end

    def put_beeper
      @robot.put_beeper
      puts @name + ' put one beeper.'
      $canvas.update
    rescue Exception  => e
             puts e.to_s
             puts e.backtrace  
    end

    def off_robot
      @robot.turn_off
      puts @name + ' turned off.'
      $canvas.update
    rescue Exception  => e
             puts e.to_s
             puts e.backtrace  
    end

  end

#used for testing only
def task 
  # $world.place_beepers(2, 1, 2)
  $world.read_world('../worlds/stair_world.txt') 
  # karel = RemoteControl.new('Ruby', 2, 5, Robota::NORTH, 3)
  karel = RemoteControl.new('Charley', 1, 1, Robota::NORTH, 3, :yellow)
  
   $window.canvas.update
rescue Exception  => e
           puts e.to_s
           puts e.backtrace  
end

if __FILE__ == $0
  $window = window(10)
  $window.run{task}
end