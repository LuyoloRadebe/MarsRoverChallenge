require_relative "views/rover_view"
require_relative "models/rover_model"
require_relative "controllers/rover_controller"

class Main
  def initialize
    @state  = RoverModel::MissionState.new()
    RoverController::input(@state)
  end

  def begin
    @view = RoverView::Begin.new(@state)
    @view.render_game(@state)
  end
end

main = Main.new
main.begin