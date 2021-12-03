# Let's define the model itself:
# We want to havve the following attributes with the following characteristics: 
# Mode: Welcome(stationary), transit
# Grid Coordinates: x,y (we can size the screen using this as input)
# Current position: x,y, [N,S,E,W]
# Movement: L,R,M 

module RoverModel
  module Direction
      L  = :L
      R  = :R
      M  = :M
  end
  
  module Orientation
    N = [:N,0]
    E = [:E,1]    
    S = [:S,2]
    W = [:W,3]
  end

  module GameState
    M   = :Marks
    R   = :Ready
    S   = :Set   
    G   = :Go
  end
 
  #mpho moloi: 
  class Position < Struct.new(:x, :y)
  end
  
  class GridCoord < Struct.new(:rows, :cols)
  end

  class Rover < Struct.new(:position, :orientation, :directions)
  end

  class MissionState < Struct.new(:game_state, :upper_right_coord, :rover)
  end

    def self.initial_mission_state   
    RoverModel::MissionState.new(
      RoverModel::GameState::S,
      RoverModel::GridCoord.new(5,5),
      [RoverModel::Rover.new(RoverModel::Position.new(1,2),Orientation::N,'LMLMLMLMM'),RoverModel::Rover.new(RoverModel::Position.new(3,3),Orientation::E,'MMRMMRMRRM')])
    # how to reference 
    # @state.game_state
    # @state.grid_size.cols | @state.grid_size.rows
    # @state.rover[].position.x | @state.rover.position.y
    # @state.rover.orientation
    # @state.rover.directions
  end
end