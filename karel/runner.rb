#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

# A class to run any task in a new thread
class Runner
  def run (task)
    Thread.new(task){|tsk|
      tsk
    }
  end
  
  # return a new Runner that can execute a task in a thread. 
  def Runner.instance() #instance
    Runner.new()
  end
end
