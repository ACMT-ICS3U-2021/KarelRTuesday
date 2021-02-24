
require_relative "harvester"
require_relative "sensor_pack"

class SparseHarvester < Harvester
    include SensorPack

    def harvest_corner()
        if next_to_a_beeper?()  
            pick_beeper()
        end
    end
end  

def task()
  world = RobotWorld.instance()
  world.read_world("../worlds/fig5-1.kwld")
  jones = SparseHarvester.new(2, 2, EAST, 0)
  jones.move()
  jones.harvest_two_rows
  #incomplete
end


if __FILE__ == $0
  screen = window(10, 50) # (size, speed)
  screen.run do
      task()
  end
end
