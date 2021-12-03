require 'ruby2d'
require_relative "views/rover_view"
require_relative "models/rover_model"
require_relative "controllers/rover_controller"

@ROVER_SIZE = 64
@GRID_BLOCK_SIZE = 64
@GRID_OFFSET_X = 380
@GRID_OFFSET_Y = 10
@TEXT_LINE = 30
@TEXT_OFFSET_X = 10
@TEXT_SIZE = 15
@WIDTH = 1280
@HEIGHT = 720  
set title: "Mars Rover Project", width: @WIDTH, height: @HEIGHT, background: 'black'

update do
  state = RoverModel::MissionState.new
  draw_window(state)
end

def draw_window(state)
  user_input = Rectangle.new(
    x: 0, y: 0,
    width: @GRID_OFFSET_X, 
    height: @HEIGHT,
    color: Color.new('#f05821'),
    z: 0
  )

  on :key do |key_event|
    if state.game_state == :Ready
      RoverController::handle_input(state,key_event)
    end
  end

end
show