#Copyright 2010 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License


require_relative "../karel/ur_robot"
require_relative "../mixins/turner"
# A class whose robots know how to sweep a short staircase of beepers
class LetterWriter < UrRobot
  include Turner
  def initialize (street, avenue, direction, beepers)
    super(street, avenue, direction, beepers)
  end
  

  def write_letter
    raise NotImplementedError, "Vous devez ecrire la methode write_letter"
  end


  def put_2_beepers
    put_beeper
    move
    put_beeper
  end

  def put_3_beepers
    put_beeper
    move
    put_beeper
    move
    put_beeper
  end

  def put_4_beepers
    put_beeper
    move
    put_beeper
    move
    put_beeper
    move
    put_beeper
  end

  def put_5_beepers
    put_beeper
    move
    put_beeper
    move
    put_beeper
    move
    put_beeper
    move
    put_beeper
  end


end