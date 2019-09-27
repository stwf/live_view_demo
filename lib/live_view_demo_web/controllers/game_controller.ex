defmodule LiveViewDemoWeb.GameController do
  use LiveViewDemoWeb, :controller

  alias LiveViewDemo.CodeBreaker

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

  def show(conn, %{"id" => _id}) do
    game = get_session(conn, :game)

    render(conn, "show.html", game: game)
  end
end
