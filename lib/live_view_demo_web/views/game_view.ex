defmodule LiveViewDemoWeb.GameView do
  use LiveViewDemoWeb, :view

  alias LiveViewDemo.CodeBreaker.Game

  def draw_guess_peg(game, pos) do
    do_draw_guess_peg(game, pos, Game.game_over?(game))
  end

  def background_reaction(game) do
    cond do
      Game.game_won?(game) ->
        "fireworks"
      true ->
        ""
    end
  end
  
  def code_break_instructions(%{turns: []}) do
    ~E"""
    Begin Breaking the Code!!! <BR> You have 10 turns remaining
    """
  end

  def code_break_instructions(%{turns: turns} = game) do
    turns_left = (10 - (turns |> Enum.count()))
    
    cond do
      (Game.game_won?(game) && (turns_left == 0)) ->
        ~E"""
          You Won On Your Last Turn!!
          <BR>
          <%= game_congrats(game) %>
        """

      (Game.game_won?(game) && (turns_left == 1)) ->
        ~E"""
          You Won With 1 turn remaining!!
          <BR>
          <%= game_congrats(game) %>
        """

      Game.game_won?(game) ->
        ~E"""
          You Won With <%= turns_left %> turns remaining!!
          <BR>
          <%= game_congrats(game) %>
        """

      Game.game_lost?(game) ->
        ~E"""
          You Lost
        """

      true ->
        ~E"""
        You have <%= turns_left %> turns remaining
        """
    end
  end

  def cb_action_btn(game) do
    game
    |> game_status
    |> do_draw_btn(game)
  end

  def do_draw_btn(:unstarted, _game) do
    ~E"""
    <button type="button" disabled>
      Evaluate
    </button>
    <div class="help">
      Black pegs - correct color in the correct spot
      <BR>
      White pegs - correct color in the wrong position
    </div>
    """
  end

  def do_draw_btn( :playing, _game) do
    ~E"""
    <button phx-click="eval-guess">
      Evaluate
    </button>
    <div class="help">
      Black pegs - correct color in the correct spot
      <BR>
      White pegs - correct color in the wrong position
    </div>
    """
  end

  def do_draw_btn(:over, %{colors: 4}) do
    handle_draw_btn([
      "4": "Play Again",
      "5": "Try an Harder Game",
      "6": "Try the Hardest game"
    ])
  end

  def do_draw_btn(:over, %{colors: 5}) do
    handle_draw_btn([
      "5": "Play Again",
      "4": "Try an Easier Game",
      "6": "Try a harder game"
    ])
  end

  def do_draw_btn(:over, %{colors: 6}) do
    handle_draw_btn([
      "6": "Play Again",
      "5": "Try an Easier Game",
      "4": "Try the Easiest Game"
    ])
  end

  def increment_btn(pos, false) do
    ~E"""
      <button phx-click="advance-color" phx-value-pos="<%= pos %>">
        +
      </button>
    """
  end

  def increment_btn(_pos, true) do
    ~E"""
      <button disabled>
        +
      </button>
    """
  end

  def decrement_btn(pos, false) do
    ~E"""
      <button phx-click="retreat-color" phx-value-pos="<%= pos %>">
        -
      </button>
    """
  end

  def decrement_btn(_pos, true) do
    ~E"""
      <button disabled>
        -
      </button>
    """
  end

  defp handle_draw_btn(btn_data) do
    Enum.map(btn_data, fn {color_count, prompt} ->
      ~s"""
      <a href="/new?colors=#{color_count}" class="button">
        #{prompt}
      </a>
      """
    end)
    |> Enum.join
    |> Phoenix.HTML.raw
  end

  defp game_congrats(%{turns: turns, colors: colors}) do
    turn_count = Enum.count(turns)
    cond do
      turn_count == 1 ->
        "So Lucky!!"
      colors == 6 && turn_count < 8 ->
        "Truly Amazing!!!"
      colors == 6 ->
        "Excellent Work!!!"
      turn_count < 6 && colors == 5 ->
        "Great Work!"
      turn_count < 6 ->
        "Very Good!"
      true ->
        "Nice Job"
    end
  end

  defp do_draw_guess_peg(game, pos, false) do
    ~E"""
      <%= increment_btn(pos, false) %>
      <div class="guess_display">
        <div class="bulb-top <%= Enum.at(game.current_guess, pos - 1) %>">
          <div class="reflection"></div>
        </div>
      </div>
      <%= decrement_btn(pos, false) %>
    """
  end

  defp do_draw_guess_peg(game, pos, true) do
    ~E"""
      <div class="guess_display">
        <div class="bulb-top <%= Enum.at(game.solution, pos - 1) %>">
          <div class="reflection"></div>
        </div>
      </div>
    """
  end

  def game_status(%{current_guess: current_guess} = game) do
    cond do
      Enum.member?(current_guess, :x) ->
        :unstarted

      Game.game_won?(game) ->
        :over

      Game.game_lost?(game) ->
        :over

      true ->
        :playing
    end
  end
end
