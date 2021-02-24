
require_relative "sensor_pack"
require_relative "field_harvester"

class Replanter < FieldHarvester
    include SensorPack

    def harvest_corner()
        if not next_to_a_beeper?() 
            put_beeper()
        else 
            pick_beeper()
            # if not next_to_a_beeper?() 
                # put_beeper()
            # end
            put_beeper() unless next_to_a_beeper?()
        end
    end
    
    
end

def task()

  world = RobotWorld.instance()
  world.read_world("../worlds/fig5-1.kwld")
  jones = Replanter.new(2, 2, EAST, 30)
  jones.harvest_field()
end


if __FILE__ == $0
  screen = window(10, 50) # (size, speed)
  screen.run do
      task()
  end
end
