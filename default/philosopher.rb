#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

# $triangle_beepers = true
require_relative 'robot'
require_relative 'turner'
require_relative 'die'

# A class of robots that can execute the dining philosophers protocol. Demonstrates
# unchecked concurrency so deadlock can result. 
class Philosopher < Robot
  include Turner
  @@die = Die.new(6)
  
  # create a new Philosopher that will run in its own thread
  def initialize(street, avenue,  direction, color=nil)
    super( street, avenue, direction, 0, color)
    world = Robota::World
    world.set_up_thread(self)    
  end
  # Think by moving awauy from the "table"
  def think(time)
    time.times do
      back_up()
      move()
    end
  end
  
  # Waste time by turning in place. This actually improves the threaded
  # behavior. 
  def spin()
    turn_around()
    turn_around()
  end
  
  # eat by moving in to the table
 def eat(time)
    # userPause("eat");
    time.times do
      move()
      back_up()
    end
  end
  
  # get two forks (beepers) to enable eating       
 def get_forks
    turn_left()
    move()
    while ! any_beepers_in_beeper_bag?()
      while not next_to_a_beeper?()
        spin()
      end
      pick_beeper()
    end
    turn_around()
    move()
    put_beeper()
    move()
    while ! any_beepers_in_beeper_bag?()
      while not next_to_a_beeper?()
        spin()
      end
      pick_beeper()
    end
    turn_around()
    move()
    put_beeper()
    turn_right()
  end
  
  # return the two forks so as to return to thinking      
 def put_forks
    pick_beeper()
    pick_beeper()
    turn_left()
    move()
    put_beeper()
    turn_around()
    move()
    move()
    put_beeper()
    turn_around()
    move()
    turn_right()
  end
  
  # The task for one philosopher (run in the thread)
 def run_task
    while true
      think(@@die.roll())
      get_forks()
      eat(@@die.roll())
      put_forks()
    end
  end
  
end

# set up the four philosophers and start them. 
def task
  north = Robota::NORTH
  west = Robota::WEST
  south = Robota::SOUTH
  east = Robota::EAST
  world = Robota::World
  world.read_world("../worlds/beepers.txt")
  p1 = Philosopher.new(2, 3, north, :red)
  p2 = Philosopher.new(4, 3, south, :green)
  p3 = Philosopher.new(3, 4, west, :blue)
  p4 = Philosopher.new(3, 2, east, :yellow)
  world.start_threads(10)
end

if __FILE__ == $0
  window(7, 9).run do
      task
  end
  
end