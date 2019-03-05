defmodule BookList.GroupTest do
  use BookList.ModelCase

  alias BookList.Group

  @valid_attrs %{blurb: "some blurb", chair: "some chair", cochair: "some cochair", name: "some name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Group.changeset(%Group{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Group.changeset(%Group{}, @invalid_attrs)
    refute changeset.valid?
  end
end
