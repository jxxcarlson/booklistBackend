defmodule BookList.StatTest do
  use BookList.ModelCase

  alias BookList.Stat

  @valid_attrs %{books: 42, books_read: 42, pages: 42, pages_read: 42, users: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Stat.changeset(%Stat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Stat.changeset(%Stat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
