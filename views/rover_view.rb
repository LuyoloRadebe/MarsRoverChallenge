require 'ruby2d'
require_relative "../models/rover_model"

#NB. This can be neatened up a lot. Consider a .env file for global constants
module RoverView
  class Begin
    def initialize(state)
      extend Ruby2D::DSL
      @ROVER_SIZE = 64
      @GRID_BLOCK_SIZE = 64
      @GRID_OFFSET_X = 380
      @GRID_OFFSET_Y = 10
      @TEXT_LINE = 30
      @TEXT_OFFSET_X = 10
      @TEXT_SIZE = 15
      @WIDTH = 1280
      @HEIGHT = 720   
    end 

    def render_game(state)
      draw_window(state)
      render_welcome(state)
      update do
        on :mouse_down do |mouse_event|
          #marks => instructions are cleared and user can (ideally) input their own instructions => ready
          if @reset_button.contains?(mouse_event.x, mouse_event.y)
            reset_game(state)
          end
          
          #set => view the rover in the initial position => go
          if @start_button.contains?(mouse_event.x, mouse_event.y)
            if state.game_state == :Set
              position_rover(state)
            end
          end

          #go => click on any rover to (ideally) watch it move real time with the given instructions
          if state.game_state == :Go
            (state.rover.length).times do |x|
              if @rover_no[x].contains?(mouse_event.x, mouse_event.y)
                move_rover(state,x)       
              end
            end
          end
        end 

        #ready => user has input the instructions they desire => set
        on :key do |key_event|
          if state.game_state == :Ready
            handle_input(state,key_event)
          end
        end
      end

      if state.game_state == :Go 
        render_rover(state)
      end
      show
    end

    private 
    def draw_window(state)
      set title: "Mars Rover Project", width: @WIDTH, height: @HEIGHT, background: 'black'
      set fps_cap: 1;
      user_input = Rectangle.new(
        x: 0, y: 0,
        width: @GRID_OFFSET_X, 
        height: @HEIGHT,
        color: Color.new('#f05821'),
        z: 0
      )
    end

    def render_welcome(state)
      @reset_button = Image.new(
        './assets/images/reset_mission.png',
        x: 15,
        y: 10,
        z: 0,
        width: 350, 
        height: 50 
      )        

      @start_button = Image.new(
        './assets/images/rover_position.png',
        x: 15,
        y: 70,
        z: 0,
        width: 350, 
        height: 50 
      ) 
      display_input(state)
      draw_grid(state)
    end

    def reset_game(state)
      state = RoverController::reset_button(state)
      @user_input.remove
      @user_coordinates.remove
      (@example.length).times do |x|
        @example[x].remove
      end
    end

    def handle_input(state,event)
      state.input.append(event.key)
    end

    def display_input(event)
    end

    def draw_grid(state)
      @GRID_PADDING = 20
      @GRID_SPACE = [900-@GRID_PADDING,720-@GRID_PADDING]
      if state.upper_right_coord.rows<state.upper_right_coord.cols
        @GRID_BLOCK_SIZE = @GRID_SPACE[0]/(state.upper_right_coord.cols+1)
      else 
        @GRID_BLOCK_SIZE = @GRID_SPACE[1]/(state.upper_right_coord.rows+1)
      end
      @GRID_DIMENSIONS = [@GRID_BLOCK_SIZE*(state.upper_right_coord.cols+1),@GRID_BLOCK_SIZE*(state.upper_right_coord.rows+1)]
      @GRID_OFFSET_X = @GRID_OFFSET_X + (@GRID_SPACE[0] - @GRID_DIMENSIONS[0])/2
      @GRID_OFFSET_Y = @GRID_OFFSET_Y + (@GRID_SPACE[1] - @GRID_DIMENSIONS[1])/2

      (state.upper_right_coord.cols+2).times do |x|
        Line.new(
          width: 1,
          color: 'white',
          y1: @GRID_OFFSET_Y,
          y2: @GRID_OFFSET_Y + @GRID_BLOCK_SIZE*(state.upper_right_coord.rows+1),
          x1: (x * @GRID_BLOCK_SIZE) + @GRID_OFFSET_X,
          x2: (x * @GRID_BLOCK_SIZE) + @GRID_OFFSET_X,
        )
      end
      (state.upper_right_coord.rows+2).times do |y|
        Line.new(
          width: 1,
          color: 'white',
          x1: @GRID_OFFSET_X,
          x2: @GRID_OFFSET_X+@GRID_BLOCK_SIZE*(state.upper_right_coord.cols+1),
          y1: (y * @GRID_BLOCK_SIZE)+ @GRID_OFFSET_Y,
          y2: (y * @GRID_BLOCK_SIZE)+ @GRID_OFFSET_Y,
        )
      end
    end

    def display_input(state) 
      @user_input = Text.new(
        "INPUT:",
        x: 10,
        y: 130,
        font: './assets/fonts/Courier_Prime/CourierPrime-Bold.ttf',
        size: 15,
        color: 'white',
        z: 2
      ) 
      @user_coordinates = Text.new(
        "FIELD COORDINATES: #{defined?(state.upper_right_coord&.cols) ? state.upper_right_coord&.cols : ''} #{defined?(state.upper_right_coord&.rows) ? state.upper_right_coord&.rows : ''}",
        x: 10,
        y: 150,
        font: './assets/fonts/Courier_Prime/CourierPrime-Bold.ttf',
        size: 15,
        color: 'white',
        z: 2
      ) 
      count = 0
      if defined?(state.rover)
        @example = []
        (state.rover.length).times do |x|
          info = ["ROVER #{x+1} POSITION AND ORIENTATION: #{state.rover[x].position.x } #{state.rover[x].position.y} #{state.rover[x].orientation[0]}", "INSTRUCTIONS #{state.rover[x].directions}"]
          (2).times do |y|
            @example[count] = Text.new(
              info[y],
              x: 10,
              y: 150 + (count+1)*20,
              font: './assets/fonts/Courier_Prime/CourierPrime-Bold.ttf',
              size: 15,
              color: 'white',
              z: 2
            )
            count = count+1
          end
        end
      end  
    end

    def display_output(state,x)
      @user_input = Text.new(
        "OUT:",
        x: 10,
        y: 270+ x*40,
        font: './assets/fonts/Courier_Prime/CourierPrime-Bold.ttf',
        size: 15,
        color: 'white',
        z: 2
      )       
      @output_coordinates = Text.new(
        "ROVER #{x+1} POSITION AND ORIENTATION: #{state.rover[x].position.x } #{state.rover[x].position.y} #{state.rover[x].orientation[0]}",
        x: 10,
        y: 290 + x*40,
        font: './assets/fonts/Courier_Prime/CourierPrime-Bold.ttf',
        size: 15,
        color: 'white',
        z: 2
      )       
    end
    #position rover and render rover may both be redundant together, one of them must go
    def position_rover(state)
      @corner_grid_map_x = ((@GRID_OFFSET_X..(@GRID_DIMENSIONS[0]+@GRID_OFFSET_X)).step(@GRID_BLOCK_SIZE).to_a)
      @corner_grid_map_y = (((@GRID_OFFSET_Y..(@GRID_DIMENSIONS[1])).step(@GRID_BLOCK_SIZE).to_a).reverse)
      
      @GRID_CENTER = (@GRID_BLOCK_SIZE-@ROVER_SIZE)/2
      @grid_map_x = ((@GRID_OFFSET_X+@GRID_CENTER..(@GRID_DIMENSIONS[0]+@GRID_OFFSET_X)+@GRID_CENTER).step(@GRID_BLOCK_SIZE).to_a)
      @grid_map_y = (((@GRID_OFFSET_Y+@GRID_CENTER..(@GRID_DIMENSIONS[1]+@GRID_CENTER)).step(@GRID_BLOCK_SIZE).to_a).reverse)
      
      @rover_no = []

      render_rover(state)
      state.game_state = :Go
    end

    def render_rover(state)
        @corner_grid_map_x = ((@GRID_OFFSET_X..(@GRID_DIMENSIONS[0]+@GRID_OFFSET_X)).step(@GRID_BLOCK_SIZE).to_a)
        @corner_grid_map_y = (((@GRID_OFFSET_Y..(@GRID_DIMENSIONS[1])).step(@GRID_BLOCK_SIZE).to_a).reverse)
        
        @GRID_CENTER = (@GRID_BLOCK_SIZE-@ROVER_SIZE)/2
        @grid_map_x = ((@GRID_OFFSET_X+@GRID_CENTER..(@GRID_DIMENSIONS[0]+@GRID_OFFSET_X)+@GRID_CENTER).step(@GRID_BLOCK_SIZE).to_a)
        @grid_map_y = (((@GRID_OFFSET_Y+@GRID_CENTER..(@GRID_DIMENSIONS[1]+@GRID_CENTER)).step(@GRID_BLOCK_SIZE).to_a).reverse)
        
        @rover_no = []
        (state.rover.length).times do |x|
        @rover_no[x] = Image.new(
        './assets/images/bb8.png',
        x: @grid_map_x[(state.rover[x].position.x)],
        y: @grid_map_y[(state.rover[x].position.y)],
        z: 0,
        rotate: state.rover[x].orientation[1]*90,
        width: 64, 
        height: 64 
      )
      Text.new(
        " #{x+1}",
        x: @corner_grid_map_x[(state.rover[x].position.x)],
        y: @corner_grid_map_y[(state.rover[x].position.y)],          
      )
      end
    end
  
    def move_rover(state,x)
      (state.rover[x].directions.length).times do |y|
        state = RoverController::move_rover(state,x,y)
        render_rover(state)
      end
      display_output(state,x)
    end
  end
end