
require_relative "robot"
require_relative "turner"

class Finder < Robot
    include Turner

    def move_to_robot() # at least one block
        move()
        while not next_to_a_robot?() 
            move()
        end
    end
  
    def empty_bag() # in Finder
        while any_beepers_in_beeper_bag?() 
            put_beeper()
        end
    end

    def slide_left() # in Finder
        turn_left()
        move()
        turn_right()
    end
    
    def move_away()
      move()
      move()
    end
end

class Carrier < Finder
  
  def clear_all()
    move()
    while next_to_a_beeper?()
      pick_beeper()
    end
    back_up()
  end

   # Arithmetic carry to next column
   def carry_one() # Facing north on 1st Street. -- Carrier class
       turn_left()
       move()           # Note:  Error shutoff here if we try to carry
                        # from 1st Street.
       put_beeper() 
       turn_around()
       move()
       turn_left()
       clear_all()
    end
end

class Checker < Finder

    # Are there enough beepers to require_relative a carry
    def enough_to_carry?() # Facing north on 1st Street. Checker class
        10.times do
            if next_to_a_beeper?() 
                pick_beeper()
            else 
                empty_bag()
                return false
            end
        end
        # Found ten beepers. Put them on 2nd street.
        move()
        empty_bag()
        back_up()
        return true
    end
end


class Adder < Finder
    def initialize(avenue, color = nil)
        super(1, avenue, NORTH, 0, color)
    end
    
    def slide_left() # in Adder
        super()
        @check.slide_left()
        @carry.slide_left()
    end

    def gather_helpers()
        @carry = Carrier.new(1, 1, EAST, INFINITY)
        @check = Checker.new(1, 1, EAST, 0)
        @carry.move_to_robot()
        @carry.turn_left()
        @check.move_to_robot()
        @check.turn_left() 
    end     

    def on_second_avenue?()
        turn_left()
        move()
        if front_is_clear?() 
            turn_around()
            move()
            turn_left()
            return false
        end
        turn_around()
        move()
        turn_left()
        return true
    end

    def add_column()
        move()
        while next_to_a_beeper?() 
            pick_beeper()
            if not next_to_a_beeper?() 
                move()
            end
        end
        turn_around()
        while front_is_clear?() 
            move()
        end
        turn_around()
        empty_bag()
        while @check.enough_to_carry?()
            @carry.carry_one()
        end
    end
    
    def move_away()
      super()
      @check.move_away()
      @carry.move_away()
    end
  
    def add_all()
        while not on_second_avenue?() 
            add_column()
            slide_left()
        end
        add_column() # don't forget the last column   
    end
end

def task
   world = RobotWorld.instance()
   world.read_world("../worlds/fig7-4.kwld")
   # world.place_beepers(3, 4, 7)
   world.show_world()
   tony = Adder.new(5)
   tony.gather_helpers()
   tony.add_all()
   tony.move_away()
   world.show_world()
end

if __FILE__ == $0
  screen = window(15, 80) # (size, speed)
  screen.run do
      task()
  end
end
