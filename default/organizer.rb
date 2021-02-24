
require_relative "harvester"

class Organizer
    # note: there is no superclass here
    def initialize()
        @karel = Harvester.new(2, 2, EAST, 0)
        @kristen = Harvester.new(4, 2, EAST, 0)
        @matt = Harvester.new(6, 2, EAST, 0)
    end

    def harvest_field()
         @karel.move()
         @karel.harvest_two_rows()
         @kristen.move()
         @kristen.harvest_two_rows()
         @matt.move()
         @matt.harvest_two_rows()
    end

end

def task()
    world = RobotWorld.instance
    world.read_world("../worlds/fig3-2.kwld")
    charlie = Organizer.new()
    charlie.harvest_field()
end

if __FILE__ == $0
  screen = window(10, 80) # (size, speed)
  screen.run do
      task()
  end
end
