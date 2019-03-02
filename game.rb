require "gosu"
require "ostruct"

class GameWindow < Gosu::Window
  JUMP_VELOCITY = -300
  STATE = {
    scroll_clouds: 0,
    scroll_x: 0,
    player: nil,
    player_velocity: 0,
    counter: 0
  }

  def initialize(*args)
    super

    @images = {
      background: Gosu::Image.new("images/background.png"),
      foreground1: Gosu::Image.new("images/foreground1.png", {tileable: true}),
      foreground2: Gosu::Image.new("images/foreground2.png", {tileable: true}),
      player1: Gosu::Image.new("images/mario1.png"),
      player2: Gosu::Image.new("images/mario2.png"),
      player3: Gosu::Image.new("images/mario3.png")
    }

    @state = OpenStruct.new(STATE)
  end

  def button_down(button)
    case button
    when Gosu::KbEscape then close
    when Gosu::KbSpace then @state.player_velocity = JUMP_VELOCITY
    end
  end

  def update
    delta_time = update_interval / 1000.0
    @state.counter = update_counter(delta_time)

    @state.scroll_clouds += delta_time * 100
    @state.scroll_x += delta_time * 150
    @state.player = next_player(@state.counter)

    # @state.player_velocity +=
    puts @state.counter

    [:scroll_x, :scroll_clouds].each {|key| reset_to_zero(key) }
  end

  def draw
    @images[:background].draw(0, 0, 0)
    @images[:foreground1].draw(-@state.scroll_clouds, 0, 0)
    @images[:foreground1].draw(-@state.scroll_clouds + @images[:foreground1].width, 0, 0)

    @images[:foreground2].draw(-@state.scroll_x, 0, 0)
    @images[:foreground2].draw(-@state.scroll_x + @images[:foreground2].width, 0, 0)

    @state.player.draw(30, @state.player_velocity + 340, 0)
  end

  def reset_to_zero(key)
    @state[key] = 0 if @state[key] > 500 # foreground image width
  end

  def next_player(counter)
    images = [@images[:player1], @images[:player2], @images[:player3]]
    index = counter.floor
    index = 0 if index >= images.length
    images[index]
  end

  def update_counter(delta_time)
    if @state.counter >= 3
      @state.counter = 0
    else
      @state.counter += 10 * delta_time
    end
  end
end

window = GameWindow.new(500, 500, false)
window.show
