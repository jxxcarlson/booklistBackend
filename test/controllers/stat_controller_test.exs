defmodule BookList.StatControllerTest do
  use BookList.ConnCase

  alias BookList.Stat
  @valid_attrs %{books: 42, books_read: 42, pages: 42, pages_read: 42, users: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, stat_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    stat = Repo.insert! %Stat{}
    conn = get conn, stat_path(conn, :show, stat)
    assert json_response(conn, 200)["data"] == %{"id" => stat.id,
      "users" => stat.users,
      "books" => stat.books,
      "books_read" => stat.books_read,
      "pages" => stat.pages,
      "pages_read" => stat.pages_read}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, stat_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, stat_path(conn, :create), stat: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Stat, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, stat_path(conn, :create), stat: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    stat = Repo.insert! %Stat{}
    conn = put conn, stat_path(conn, :update, stat), stat: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Stat, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    stat = Repo.insert! %Stat{}
    conn = put conn, stat_path(conn, :update, stat), stat: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    stat = Repo.insert! %Stat{}
    conn = delete conn, stat_path(conn, :delete, stat)
    assert response(conn, 204)
    refute Repo.get(Stat, stat.id)
  end
end
