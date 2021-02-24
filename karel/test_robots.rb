#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

$graphical = false
require "test/unit"
require_relative "robota"
require_relative "ur_robot"
require_relative "direction"
require_relative "robot_world"
require_relative "robot"
require_relative "../tasks/stair_sweeper"

=begin
 Generally requires a text based world - see robota.rb 
=end

class TestRobots < Test::Unit::TestCase
  
  def setup
    super
    @world = Robota::World #note, not a new world for each test
    @world.reset
    @karel =  UrRobot.new(3, 3, Robota::NORTH, 0)
    
#    @world.set_delay(100)
  end
  
  def test_turn
    @karel.turn_left
    @karel.assert_facing(Robota::WEST)
    @karel.turn_left
    @karel.assert_facing(Robota::SOUTH)
    @karel.turn_left
    @karel.assert_facing(Robota::EAST)
    @karel.turn_left
    @karel.assert_facing(Robota::NORTH)
    @karel.assert_no_neighbors()
    @karel.assert_running()
    @karel.assert_front_clear()
    @karel.turn_off()
    @karel.assert_not_running()
  end
  
  def test_simple_move
    @karel.move
    @karel.assert_street(4)
    @karel.assert_avenue(3)
    @karel.turn_left
    @karel.move
    @karel.assert_street(4)
    @karel.assert_avenue(2)
    @karel.move
    #@karel.move  
  end
  
  def test_pick_put
    @world.place_beeper(3, 3)
    @karel.pick_beeper
    @karel.assert_beepers(1)
    @karel.assert_some_beepers()
    @karel.put_beeper
    @karel.assert_beepers(0)
    # @karel.assert_beepers(1)
  end
  
  def test_move
    #@world.place_e_w_wall(2, 3, 1)
    #@world.clear
    @world.read_world("../worlds/beepers.txt")
    @karel = UrRobot.new(4, 3, Robota::SOUTH, 0)
    @world.show_world_with_robots()
    @karel.move
    @karel.turn_left
    @world.show_world_with_robots()
    # @world.save_world("../worlds/other.txt")
    @karel.turn_left
    @karel.turn_left
    puts "neighbors: " + @karel.neighbors.to_s
    @karel.assert_facing(Robota::WEST)
    #   begin
    #     @karel.move
    #     fail
    #   rescue FrontIsBlocked
    #     #nothing
    #   end
  end
  
  def test_misc
    assert_equal("North", Robota::NORTH.to_s)
  end
  
  def testExceptions
    #  @karel.pick_beeper
    assert_raise(NoBeepers){@karel.pick_beeper}
#    begin
#      @karel.pick_beeper
#    rescue NoBeepers
#      puts "caught no beeper error"
#    end
    @karel = UrRobot.new(1, 1, Robota::SOUTH, 0)
    @karel.assert_front_blocked
    #   @karel.put_beeper
    #@karel.turnRight
    @karel.turn_off
    puts @karel.to_s
    assert_raise(RobotNotRunning){ @karel.turn_left}
#    begin
#      @karel.turn_left
#      fail
#    rescue RobotNotRunning
#      #nothing
#    end
    @karel = UrRobot.new(1, 1, Robota::SOUTH, 0)
    assert_raise(FrontIsBlocked){@karel.move}
    assert_raise(RobotNotRunning){ @karel.turn_left}
  end
  
  def test_robots
    @karel = Robot.new(1, 1, Robota::NORTH, 3)
    assert(@karel.any_beepers_in_beeper_bag?)  
    assert(@karel.facing_north?)
    assert_equal(false, @karel.next_to_a_beeper?)
    assert_equal(false, @karel.facing_east?)
    assert(@karel.front_is_clear?)
    @karel.turn_left
    assert_equal(false, @karel.front_is_clear?)
  end
  
  def test_neighbors
    @charlie = Robot.new(3, 3, Robota::EAST, 0)
    @mary = Robot.new(3, 3, Robota::NORTH, 1)
    val = @karel.neighbors.each{|neighbor| puts neighbor.to_s}
    assert_equal("Array", val.class.to_s)
    assert_equal(2, val.length)
    @world.assert_robots_at(3, 3)
    assert_raise(NoBeepers){@world.assert_beepers_at(3,3)}
    @world.place_beeper(3,3)
    @world.assert_beepers_at(3,3)
    assert(@charlie.next_to_a_robot?)
    @karel.assert_at(3, 3)
  end
  
  def test_pause
    @karel =  UrRobot.new(3, 3, Robota::NORTH, 1)
    @karel.set_pausing(false)
    @karel.move
    @karel.put_beeper
  end
 

  def test_threads
    @karel = StairSweeper.new(1, 1, Robota::EAST, 0)
    Robota::World.read_world("../worlds/beepers.txt")
    Robota::World.set_up_thread(@karel){@karel.turn_left; @karel.move}
#    STDIN.gets
    Robota::World.start_threads
    puts @karel.to_s
  end
end