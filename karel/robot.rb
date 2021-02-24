#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

require_relative 'ur_robot'
require_relative '../mixins/sensor_pack'

# A class of robots that has sensing capabilities as well as actions. 
class Robot < UrRobot
  
  include SensorPack
  
end