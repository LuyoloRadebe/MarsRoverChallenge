module RoverController

  # populates user input string into an array to parse
  def self.handle_input(state)
    key_count = 0
  end

  # parses array into the mission_state model structure
  def self.process_input
  end
  #RoverModel::MissionState.new(GameState::W,RoverModel::GridCoord.new(6,3),[RoverModel::Rover.new(RoverModel::Position.new(1,2),Orientation::N,'LMLMLMLMM'),RoverModel::Rover.new(RoverModel::Position.new(3,3),Orientation::E,'MMRMMRMRRM')])     
  # how to reference 
  # @state.game_state
  # @state.grid_size.cols | @state.grid_size.rows
  # @state.rover[].position.x | @state.rover.position.y
  # @state.rover.orientation
  # @state.rover.directions
  def self.reset_button(state)
    state.rover.clear
    state.game_state = :Ready
    state
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