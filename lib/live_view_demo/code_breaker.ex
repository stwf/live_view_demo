defmodule LiveViewDemo.CodeBreaker do
  @moduledoc """
  The CodeBreaker context.
  """

  import Ecto.Query, warn: false

  alias LiveViewDemo.CodeBreaker.Game
  alias LiveViewDemo.CodeBreaker.Turn

  @colorlist ~w(a b c d e f)a

  def create_game_for_user(user_id, %{colors: colors}) do
    game_id = UUID.uuid4()

    game = %Game{
      id: game_id,
      user_uid: user_id,
      colors: colors,
      solution: generate_solution(colors),
      current_guess: Enum.map(1..colors, fn _ -> :x end),
      turns: []
    }

    {:ok, game}
  end

  def generate_solution(colors) do
    Enum.reduce(1..colors, [], fn _, a -> [Enum.random(@colorlist) | a] end)
  end

  def evaluate(guess, solution, colors) do
    it_colors = colors - 1
    solution = Enum.reduce(0..it_colors, solution, &exact_checker(&1, &2, guess))
    solution = Enum.reduce(0..it_colors, solution, &partial_checker(&1, &2, guess))

    exacts = Enum.count(solution, fn p -> p == :exact end)
    partials = Enum.count(solution, fn p -> p == :partial end)

    results = map_pegs(exacts, :b) ++ map_pegs(partials, :w)

    %Turn{guess: guess, result: results}
  end

  def exact_checker(i, s, guess) do
    if Enum.at(guess, i) == Enum.at(s, i) do
      List.replace_at(s, i, :exact)
    else
      s
    end
  end

  def partial_checker(i, s, guess) do
    if Enum.member?(s, Enum.at(guess, i)) && Enum.at(s, i) != :exact do
      targ = Enum.at(guess, i)
      spot = Enum.find_index(s, fn i -> i == targ end)
      List.replace_at(s, spot, :partial)
    else
      s
    end
  end

  def map_pegs(0, _), do: []

  def map_pegs(i, peg), do: Enum.map(1..i, fn _ -> peg end)

  def find_exact_matches(results, [], []), do: results

  def find_exact_matches(results, [g_peg | g_others], [s_peg | s_others]) do
    results =
      if g_peg == s_peg do
        [:b | results]
      else
        results
      end

    find_exact_matches(results, g_others, s_others)
  end

  def find_partial_matches(results, _, _), do: results
end
