
require_relative 'harvester'

class FieldHarvester < Harvester

    def harvest_field() 
        move()
        harvest_two_rows()
        position_for_next_harvest()
        harvest_two_rows()
        position_for_next_harvest()
        harvest_two_rows()
        move()
    end
end
def task()
    world = RobotWorld.instance()
    world.read_world("../worlds/fig3-2.kwld")
    jim = FieldHarvester.new(2, 2, EAST, 0)
    jim.harvest_field()
    jim.turn_off()
end
      
if __FILE__ == $0
    screen = window(10, 80)
    screen.run do
        task()
    end
end
