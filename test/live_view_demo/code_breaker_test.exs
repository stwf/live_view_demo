defmodule LiveViewDemo.CodeBreakerTest do
  use LiveViewDemo.DataCase

  alias LiveViewDemo.CodeBreaker

  describe "games" do
    alias LiveViewDemo.CodeBreaker.Game

    @valid_attrs %{colors: 42, solution: "some solution", user_uid: "some user_uid"}
    @update_attrs %{
      colors: 43,
      solution: "some updated solution",
      user_uid: "some updated user_uid"
    }
    @invalid_attrs %{colors: nil, solution: nil, user_uid: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CodeBreaker.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert CodeBreaker.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert CodeBreaker.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = CodeBreaker.create_game(@valid_attrs)
      assert game.colors == 42
      assert game.solution == "some solution"
      assert game.user_uid == "some user_uid"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CodeBreaker.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, %Game{} = game} = CodeBreaker.update_game(game, @update_attrs)
      assert game.colors == 43
      assert game.solution == "some updated solution"
      assert game.user_uid == "some updated user_uid"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = CodeBreaker.update_game(game, @invalid_attrs)
      assert game == CodeBreaker.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = CodeBreaker.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> CodeBreaker.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = CodeBreaker.change_game(game)
    end
  end

  describe "turns" do
    alias LiveViewDemo.CodeBreaker.Turn

    @valid_attrs %{game_id: "some game_id", guess: "some guess", results: "some results"}
    @update_attrs %{
      game_id: "some updated game_id",
      guess: "some updated guess",
      results: "some updated results"
    }
    @invalid_attrs %{game_id: nil, guess: nil, results: nil}

    def turn_fixture(attrs \\ %{}) do
      {:ok, turn} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CodeBreaker.create_turn()

      turn
    end

    test "list_turns/0 returns all turns" do
      turn = turn_fixture()
      assert CodeBreaker.list_turns() == [turn]
    end

    test "get_turn!/1 returns the turn with given id" do
      turn = turn_fixture()
      assert CodeBreaker.get_turn!(turn.id) == turn
    end

    test "create_turn/1 with valid data creates a turn" do
      assert {:ok, %Turn{} = turn} = CodeBreaker.create_turn(@valid_attrs)
      assert turn.game_id == "some game_id"
      assert turn.guess == "some guess"
      assert turn.results == "some results"
    end

    test "create_turn/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CodeBreaker.create_turn(@invalid_attrs)
    end

    test "update_turn/2 with valid data updates the turn" do
      turn = turn_fixture()
      assert {:ok, %Turn{} = turn} = CodeBreaker.update_turn(turn, @update_attrs)
      assert turn.game_id == "some updated game_id"
      assert turn.guess == "some updated guess"
      assert turn.results == "some updated results"
    end

    test "update_turn/2 with invalid data returns error changeset" do
      turn = turn_fixture()
      assert {:error, %Ecto.Changeset{}} = CodeBreaker.update_turn(turn, @invalid_attrs)
      assert turn == CodeBreaker.get_turn!(turn.id)
    end

    test "delete_turn/1 deletes the turn" do
      turn = turn_fixture()
      assert {:ok, %Turn{}} = CodeBreaker.delete_turn(turn)
      assert_raise Ecto.NoResultsError, fn -> CodeBreaker.get_turn!(turn.id) end
    end

    test "change_turn/1 returns a turn changeset" do
      turn = turn_fixture()
      assert %Ecto.Changeset{} = CodeBreaker.change_turn(turn)
    end
  end
end
