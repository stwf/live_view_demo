defmodule LiveViewDemo.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :user_uid, :string
      add :colors, :integer
      add :solution, :string

      timestamps()
    end
  end
end
