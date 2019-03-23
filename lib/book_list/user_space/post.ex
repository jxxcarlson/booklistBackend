defmodule BookList.UserSpace.Post do

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias BookList.Repo
  alias BookList.UserSpace.Post

  schema "posts" do
    field :title, :string
    field :content, :string
    field :author_name, :string
    field :group_id, :integer
    field :tags, {:array, :string}, default: []

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :author_name, :group_id, :tags ])
    |> validate_required([:title, :author_name, :group_id])
  end

  def by_group_id(query, id) do
    from p in query,
         where: p.group_id == ^id
  end

  def by_author_name(query, author_name) do
    from i in query,
         where: i.author_name == ^author_name
  end

  def get_by_group_id(id) do
    Post |> by_group_id(id) |> Repo.all
  end

  def get_by_author_name(author_name) do
    Post |> by_author_name(author_name) |> Repo.all
  end

end
