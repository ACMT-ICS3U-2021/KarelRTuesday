#Copyright 2010 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License


require_relative "letter_writer"
require_relative "../mixins/turner"
# A class whose robots know how to sweep a short staircase of beepers
class LWriter < LetterWriter
  include Turner
  def initialize (street, avenue, direction, beepers)
    super(street, avenue, direction, beepers)
  end
  

  def write_letter
    put_5_beepers
    turn_around
    move
    move
    move
    move
    turn_left
    move
    put_2_beepers
  end

end