
module Assertions

  # Assert the robot is on a specified street
  def assert_street(street)
    raise "Robot is not on street: " + street.to_s if @street != street
  end
  
  # Assert the robot is not on a specified street
  def assert_not_street(street)
    raise "Robot is on street: " + street.to_s if @street == street
  end
  
  # Assert the robot is on a specified avenue
  def assert_avenue(avenue)
    raise "Robot is not on avenue: " + avenue.to_s if @avenue != avenue
  end
  
  # Assert the robot is not on a specified avenue
  def assert_not_avenue(avenue)
    raise "Robot is on avenue: " + avenue.to_s if @avenue == avenue
  end
  
  # Assert the robot is on a specified corner
  def assert_at(street, avenue)
    assert_street(street)
    assert_avenue(avenue)
  end
  
  # Assert the robot is not on a specified corner
  def assert_not_at(street, avenue)
    raise "Robot is at: (" + street.to_s + ", " + avenue.to_s + ")" if @street == street && avenue == avenue
  end
  
  # Assert the robot is facing the given direction
  def assert_facing(direction)
    raise "Robot is not facing: " + direction.to_s if @direction != direction
  end
  
  # Assert the robot is not facing the given direction
  def assert_not_facing(direction)
    raise "Robot is facing: " + direction.to_s if @direction == direction
  end
  
  # Assert the robot has precisely the number of beepers given in its beeper bag
  def assert_beepers(howMany)
    raise "Robot does not have exactly " + howMany.to_s + " beepers." if @beepers != howMany    
  end

  # Assert the robot does not have precisely the number of beepers given in its beeper bag
  def assert_not_beepers(howMany)
    raise "Robot does have exactly " + howMany.to_s + " beepers." if @beepers == howMany    
  end
  
  # Assert the robot has some beepers (i.e. not 0)
  def assert_some_beepers()
    raise "Robot has no beepers " if @beepers == 0    
  end
  
  # Assert the robot is running
  def assert_running()
    raise "Robot is not running" if not running?()
  end

  # Assert the robot is not running
  def assert_not_running()
    raise "Robot is running" if running?()
  end  
  
  # Assert the robot's front is clear
  def assert_front_clear()
      begin
          street = @direction.next_street(@street, @avenue)
          avenue = @direction.next_avenue(@street, @avenue)
      rescue FrontIsBlocked
          raise "Robot is blocked." 
      end
  end
  # Assert the robot's front is blocked
  def assert_front_blocked()
      begin
          street = @direction.next_street(@street, @avenue)
          avenue = @direction.next_avenue(@street, @avenue)
          raise "Robot's front is clear." 
      rescue FrontIsBlocked
        # nothing
      end
  end
  
  # Assert a robot has at least one neighbor
  def assert_neighbors()
    raise "Robot has no neighbor" if neighbors.empty?()
  end
  # Assert a robot has no neighbors
  def assert_no_neighbors()
    raise "Robot has no neighbor" if not neighbors.empty?()
  end

end