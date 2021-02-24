
require_relative "ur_robot"

# class Binder 
  # def initialize(object, methodName)
    # @message = object.method(methodName)
  # end
#   
#   
  # def call()
    # @message.call()
  # end
#   
# end

# supplies lists of no argument functions to be 
# executed by a client
class RentAJobber 

    def initialize()
        @actions = []
    end

    def add_action(action)
        @actions << action
    end
            
    def rent()
        return @actions.clone()    #Don't let the client modify @actions.
    end 
end     

def do_all(list)
  list.each do |what|
    what.call()
  end
end  

def advert()
  print("Rich's Rent A Job")
end   

def task()
  # advert()
    rich = RentAJobber.new()
    # rich.add_action(Proc.new do advert() end)
    rich.add_action(method(:advert) )
    worker = UrRobot.new(1, 1, NORTH, 1)
    task = worker.method(:move) 
    rich.add_action(task)     # add a method bound to worker
    task = worker.method(:turn_left) 
    rich.add_action(task)
    
    worker = UrRobot.new(1, 2, NORTH, 0)
    task = worker.method(:move) 
    rich.add_action(task)     # add methods bound to a different
    rich.add_action(task)     # worker

    # worker.turn_off()
    task_list = rich.rent()
    
    task_list.each do |what|
      what.call()
    end
    
    # do_all(task_list)
  
  
end

if __FILE__ == $0
  screen = window(10, 80) # (size, speed)
  screen.run do
      task()
  end
end
