defmodule BookList.Stat do
  use BookList.Web, :model

  schema "stats" do
    field :users, :integer
    field :books, :integer
    field :books_read, :integer
    field :pages, :integer
    field :pages_read, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:users, :books, :books_read, :pages, :pages_read])
    |> validate_required([:users, :books, :books_read, :pages, :pages_read])
  end
end
