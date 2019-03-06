defmodule BookList.UserSpace.Group do
  # use BookListWeb, :model

  use Ecto.Schema
  import Ecto.Changeset

  alias BookList.UserSpace.Group
  alias BookList.Repo

  @doc"""
  cs = Group.changeset %Group{}, %{"chair": "jxxcarlson", "name": "Trillium"}

  Repo.insert cs

  Repo.all(Group)

  g = Repo.get(Group, 1)

  cs = Group.changeset g, %{"cochair": "dilibop"}

  Repo.update(cs)

  cs = Group.changeset g, %{"members": ["jxxcarlson", "dilibop"]}

  cs = Group.changeset g, %{"blurb": "This is a test."}
"""
  schema "groups" do
    field :name, :string
    field :chair, :string
    field :cochair, :string
    field :blurb, :string
    field :members, {:array, :string}

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :chair, :cochair, :blurb, :members])
    |> validate_required([:name, :chair])
  end
end
