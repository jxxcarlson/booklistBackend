defmodule BookList.BookSpace.Book do
  use Ecto.Schema
  import Ecto.Changeset


  schema "books" do
    field :author, :string
    field :notes, :string
    field :pages, :integer
    field :pages_read, :integer
    field :public, :boolean, default: false
    field :rating, :integer
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author, :notes, :pages, :pages_read, :rating, :public])
    |> validate_required([:title, :author, :notes, :pages, :pages_read, :rating, :public])
  end
end
