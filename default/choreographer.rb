
require_relative "harvester"

class Choreographer < Harvester

    def initialize(street, avenue, direction, beepers, color = nil)  
        super    
        @dancers = []
    end

    # Add a dancer robot to the dance team
    def add_dancer(dancer)
        @dancers << dancer
    end

    # Move the entire team forward 
    def move()  
        super()
        @dancers.each do |dancer|
            dancer.move()
        end
    end
        
    # turn the entire team left 
    def turn_left()  
        super()
        @dancers.each do |dancer|
            dancer.turn_left()
        end
    end
        
    # turn the entire team off 
    def turn_off()  
        super()
        @dancers.each do |dancer|
            dancer.turn_off()
        end
    end
        
    # pick a beeper by the entire team  
    def pick_beeper()  
        super()
        @dancers.each do |dancer|
            dancer.pick_beeper()
        end
    end
        
    # put a beeper by the entire team  
    def put_beeper()  
        super()
        @dancers.each do |dancer|
            dancer.put_beeper()
        end
    end
    
        def clone()
            result = super() # get the simple clone
            result.set_dancers(@dancers.clone())
            return result
        end
        
    protected
      def set_dancers(array)
        @dancers = array
      end

          
end

def task()
  world = RobotWorld.instance()
  world.read_world("../worlds/fig3-2.kwld")
  martha = Choreographer.new(2, 2, EAST, 0)
    dancer = UrRobot.new(4, 2, EAST, 0)
    martha.add_dancer(dancer)
    dancer = UrRobot.new(6, 2, EAST, 0)
    martha.add_dancer(dancer)
    martha.move()
    martha.harvest_two_rows()
    martha.move()
end

if __FILE__ == $0

  screen = window(10, 50) # (size, speed)
  screen.run do 
     task() 
  end

end

