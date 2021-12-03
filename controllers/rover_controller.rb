module RoverController
  include RoverModel  # populates user input string into an array to parse
  def self.input(state)
    include RoverModel
    input_a = []
    input_b = []
    count = 1
    puts "Welcome to the Mars Rover Challenge. Enter grid coordinates."
    input = gets
    state.upper_right_coord = RoverModel::GridCoord.new(input[0].to_i,input[2].to_i)
    state.rover = []
    while(count > 0)
      state.rover[count-1] = RoverModel::Rover.new()
      puts "Enter Rover #{count} coordinates <row column> and orientation."
      input_a = gets
      state.rover[count-1].position = RoverModel::Position.new(input_a[0].to_i,input_a[2].to_i)  
      case input_a[4]&.upcase
      when "N"
        state.rover[count-1].orientation = RoverModel::Orientation::N
      when "E"
        state.rover[count-1].orientation = RoverModel::Orientation::E
      when "W"
        state.rover[count-1].orientation = RoverModel::Orientation::W
      when "S"
        state.rover[count-1].orientation = RoverModel::Orientation::S    
      end        
      puts "Enter Rover #{count} instructions."
      state.rover[count-1].directions = (gets.chomp).upcase
      puts "Enter  another rover? y/n."
      input_b = gets
      if input_b[0].upcase == 'Y'
        count = count + 1
      else
        count = 0
      end
    end
  end



  def self.set_orientation(state_orientation,char)
    puts "in get orientation"
    puts char
    case char
    when ("N" || "n")
      state_orientation = RoverModel::Orientation::N
    when (E || e)
      state_orientation = RoverModel::Orientation::E
    when ("W" || "w")
      state_orientation = RoverModel::Orientation::E
    when ("S" || "s")
      state_orientation = RoverModel::Orientation::E            
    end
    output
  end
  #RoverModel::MissionState.new(GameState::W,RoverModel::GridCoord.new(6,3),[RoverModel::Rover.new(RoverModel::Position.new(1,2),Orientation::N,'LMLMLMLMM'),RoverModel::Rover.new(RoverModel::Position.new(3,3),Orientation::E,'MMRMMRMRRM')])     
  # how to reference 
  # @state.game_state
  # @state.grid_size.cols | @state.grid_size.rows
  # @state.rover[].position.x | @state.rover.position.y
  # @state.rover.orientation
  # @state.rover.directions
  def self.reset_button(state)
    state  = RoverModel::MissionState.new()
    RoverController::input(@state)
  end

  def self.start_button(state)
    state.game_state = :Set
    state
  end  

  def self.move_rover(state,x,y)
    case state.rover[x].directions[y]
    when 'M'
      state = move_forward(state,x)
    when 'L'
      state = rotate_left(state,x)
    when 'R'
      state = rotate_right(state,x)        
    end
    state 
  end

  def self.rotate_right(state,x)
    case state.rover[x].orientation[0]
    when :N
      state.rover[x].orientation = RoverModel::Orientation::E
    when :S
      state.rover[x].orientation = RoverModel::Orientation::W
    when :E
      state.rover[x].orientation = RoverModel::Orientation::S
    when :W
      state.rover[x].orientation = RoverModel::Orientation::N
    end
    state
  end

  def self.rotate_left(state,x)
    case state.rover[x].orientation[0]
    when :N
      state.rover[x].orientation = RoverModel::Orientation::W
    when :S
      state.rover[x].orientation = RoverModel::Orientation::E
    when :E
      state.rover[x].orientation = RoverModel::Orientation::N
    when :W
      state.rover[x].orientation = RoverModel::Orientation::S
    end
    state
  end

  def self.move_forward(state,x)
    case state.rover[x].orientation[0]
    when :N
      state.rover[x].position.y = state.rover[x].position.y+1
    when :S
      state.rover[x].position.y = state.rover[x].position.y-1
    when :E
      state.rover[x].position.x = state.rover[x].position.x+1
    when :W
      state.rover[x].position.x = state.rover[x].position.x-1
    end
    state
  end
end

#