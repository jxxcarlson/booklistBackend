defmodule BookList.UserSpace.Group do
  # use BookListWeb, :model

  use Ecto.Schema
  import Ecto.Changeset

  alias BookList.UserSpace.Group
  alias BookList.Repo

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
    |> cast(params, [:firstName, :chair, :cochair, :blurb])
    |> validate_required([:firstName, :chair, :cochair, :blurb])
  end
end
