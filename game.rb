require "gosu"
require "ostruct"

class GameWindow < Gosu::Window
  STATE = {
    scroll_clouds: 0,
    scroll_x: 0,
    player: nil
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

    end
  end

  def update
    @state.scroll_clouds += 1.0
    @state.scroll_x += 1.5
    @state.player = random_player()

    [:scroll_x, :scroll_clouds].each {|key| reset_to_zero(key) }
  end

  def draw
    @images[:background].draw(0, 0, 0)
    @images[:foreground1].draw(-@state.scroll_clouds, 0, 0)
    @images[:foreground1].draw(-@state.scroll_clouds + @images[:foreground1].width, 0, 0)

    @images[:foreground2].draw(-@state.scroll_x, 0, 0)
    @images[:foreground2].draw(-@state.scroll_x + @images[:foreground2].width, 0, 0)

    @state.player.draw(30, 340, 0)
  end

  def reset_to_zero(key)
    @state[key] = 0 if @state[key] > 500 # foreground image width
  end

  def random_player
    [@images[:player1], @images[:player2], @images[:player3]].sample
  end
end

window = GameWindow.new(500, 500, false)
window.show
