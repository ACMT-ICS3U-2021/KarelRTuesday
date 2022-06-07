#!/opt/local/bin/ruby
#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

$graphical = true

require_relative "h_writer"
require_relative "e_writer"
require_relative "l_writer"
require_relative "o_writer"
require_relative "../karel/robota"

# a task for a stair sweeper
def task()
  world = Robota::World
  
  h = HWriter.new(3, 2, Robota::NORTH, 12)
  e = EWriter.new(3, 7, Robota::NORTH, 11)
  l1 = LWriter.new(3, 11, Robota::NORTH, 11)
  l2 = LWriter.new(3, 15, Robota::NORTH, 11)
  o = OWriter.new(3, 19, Robota::NORTH, 12)
  
  h.write_letter
  e.write_letter
  l1.write_letter
  l2.write_letter
  o.write_letter

end

if __FILE__ == $0
  if $graphical
     screen = window(30, 80) # (size, speed)
     screen.run do
       task
     end
   else
     task
   end
end