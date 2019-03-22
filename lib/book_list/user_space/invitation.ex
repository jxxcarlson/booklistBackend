defmodule BookList.UserSpace.Invitation do
  # use BookListWeb, :model

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias BookList.UserSpace.Invitation
  alias BookList.UserSpace.User
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
  schema "invitations" do
    field :invitee, :string
    field :inviter, :string
    field :group_name, :string
    field :group_id, :integer
    field :status, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:invitee, :inviter, :group_name, :group_id, :status ])
    |> validate_required([:invitee, :inviter])
  end



end
