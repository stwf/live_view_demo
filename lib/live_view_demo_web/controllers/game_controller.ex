defmodule LiveViewDemoWeb.GameController do
  use LiveViewDemoWeb, :controller

  alias LiveViewDemo.CodeBreaker
  alias LiveViewDemo.CodeBreaker.Game

  def index(conn, _params) do
    user =
      case get_session(conn, :user) do
        nil ->
          put_session(conn, :user, %{games: 0, wins: 0})
          %{games: 0, wins: 0}

        user ->
          user
      end

    render(conn, "index.html", user: user)
  end

  def new(conn, %{"colors" => colors}) do
    case CodeBreaker.create_game_for_user(1, %{colors: String.to_integer(colors)}) do
      {:ok, game} ->
        conn
        |> put_session(:game, game)
        |> redirect(to: Routes.game_path(conn, :show, game))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"game" => %{"colors" => colors}}) do
    case CodeBreaker.create_game_for_user(1, %{colors: String.to_integer(colors)}) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: Routes.game_path(conn, :show, game))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    game = get_session(conn, :game)

    render(conn, "show.html", game: game)
  end

  def edit(conn, %{"id" => id}) do
    game = CodeBreaker.get_game!(id)
    changeset = CodeBreaker.change_game(game)
    render(conn, "edit.html", game: game, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = CodeBreaker.get_game!(id)

    case CodeBreaker.update_game(game, game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game updated successfully.")
        |> redirect(to: Routes.game_path(conn, :show, game))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", game: game, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = CodeBreaker.get_game!(id)
    {:ok, _game} = CodeBreaker.delete_game(game)

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: Routes.game_path(conn, :index))
  end
end
