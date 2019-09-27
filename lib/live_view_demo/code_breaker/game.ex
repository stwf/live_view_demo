defmodule LiveViewDemo.CodeBreaker.Game do
  defstruct id: nil, colors: 3, current_guess: [], solution: [], turns: [], user_uid: nil

  def game_over?(game), do: game_lost?(game) || game_won?(game)

  def game_won?(%{turns: []}), do: false

  def game_won?(%{colors: colors, turns: [%{result: result} | _rest]}) do
    Enum.all?(result, fn i -> i == :b end) && Enum.count(result) == colors
  end

  def game_lost?(%{turns: turns}) do
    Enum.count(turns) == 10
  end
end
