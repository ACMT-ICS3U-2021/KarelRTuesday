

require_relative 'ur_robot'

# Manage a team of worker robots, each of which knows their job   
class Contractor
    def initialize
        @workers = []
    end

private
    def gather_team()
        # worker = Mason.new(1, 2, EAST, INFINITY)
        # @workers << worker
        # worker = Roofer.new(5, 1, EAST, INFINITY)
        # @workers << worker
        # worker = Carpenter.new(1, 5, EAST, INFINITY)
        # @workers << worker
        @workers << Mason.new(1, 2, EAST, INFINITY)
        @workers << Roofer.new(5, 1, EAST, INFINITY)
        @workers << Carpenter.new(1, 5, EAST, INFINITY)
        # @workers << Worker.new(1, 1, EAST, INFINITY)
    end
    
public
    # Put the entire team to work
    def build_house()    
        gather_team()
        @workers.each do |worker|
            worker.get_to_work()
        end
     end

end

class Worker < UrRobot
    def get_to_work()
        raise NotImplementedError.new('get_to_work error for ' + self.inspect)
    end
end

class Roofer < Worker
    def get_to_work()
        make_roof()
    end
    
    private
    
    def make_roof()
       make_left_gable()
       make_right_gable()
    end
        
    def make_left_gable()
        puts 'making left gable'
    end
    
    def make_right_gable()
        puts 'making right gable'
    end
    
end

class Mason < Worker
    def get_to_work()
        build_wall()
        move_to_second_wall_base()
        build_wall()
    end
  
  private      
    def build_wall()
        puts "building wall"
    end
    
    def move_to_second_wall_base()
        puts "moving to second wall base"
    end
end

class Carpenter < Worker
    def get_to_work()
        puts "working"
    end
 
 private   
    def make_window()
        puts "making window"
    end
    
    def make_door()
        puts "making door"
    end
end

def task()
  kristin = Contractor.new()
  kristin.build_house()
end


if __FILE__ == $0
  screen = window(10, 80) # (size, speed)
  screen.run do
      task()
  end
end
