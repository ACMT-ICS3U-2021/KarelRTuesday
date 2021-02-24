#Copyright 2012 Joseph Bergin
#License: Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License

# Creates a die object with any number of faces. If you roll a die you get a random integer between 1 and the number
# of faces. You can create a physically impossible die with this, of course, with, say, seven faces.  
class Die
  # Create a new die with the specified number of faces
  def initialize(faces)
    @bound = faces
  end
  
  # Roll the die to get a random integer between 1 and the number of faces. 
  def roll
    return 1 + rand(@bound)
  end
end
