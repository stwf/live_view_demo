defmodule LiveViewDemo.CodeBreaker.Turn do
  defstruct game_id: nil, guess: [], result: []

  def increment_item(:x, 1), do: :a
  def increment_item(:a, 1), do: :b
  def increment_item(:b, 1), do: :c
  def increment_item(:c, 1), do: :d
  def increment_item(:d, 1), do: :e
  def increment_item(:e, 1), do: :f
  def increment_item(:f, 1), do: :a

  def increment_item(:x, -1), do: :f
  def increment_item(:a, -1), do: :f
  def increment_item(:b, -1), do: :a
  def increment_item(:c, -1), do: :b
  def increment_item(:d, -1), do: :c
  def increment_item(:e, -1), do: :d
  def increment_item(:f, -1), do: :e
end
