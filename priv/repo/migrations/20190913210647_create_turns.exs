defmodule LiveViewDemo.Repo.Migrations.CreateTurns do
  use Ecto.Migration

  def change do
    create table(:turns) do
      add :game_id, :string
      add :results, :string
      add :guess, :string

      timestamps()
    end
  end
end
