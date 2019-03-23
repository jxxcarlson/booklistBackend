defmodule BookList.UserSpace.Invitation do

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias BookList.Repo
  alias BookList.UserSpace.Invitation

  schema "invitations" do
    field :invitee, :string
    field :inviter, :string
    field :group_name, :string
    field :group_id, :integer
    field :status, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:invitee, :inviter, :group_name, :group_id, :status ])
    |> validate_required([:invitee, :inviter])
  end

  def by_id(query, id) do
    from i in query,
         where: i.group_id == ^id
  end

  def get_by_id(id) do
    Invitation |> by_id(id) |> Repo.all
  end

end
