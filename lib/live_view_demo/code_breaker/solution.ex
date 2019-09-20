defmodule LiveViewDemo.CodeBreaker.Solution do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :exact, :integer
    field :partial, :integer
    field :solution, :string
    field :user_uid, :string

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:user_uid, :colors, :solution])
    |> validate_required([:user_uid, :colors, :solution])
  end
end
