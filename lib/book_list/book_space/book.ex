defmodule BookList.BookSpace.Book do
  use Ecto.Schema
  import Ecto.Changeset


  schema "books" do
    field :author, :string
    field :notes, :string, default: "Just started."
    field :pages, :integer, default: 10
    field :pages_read, :integer, default: 0
    field :public, :boolean, default: false
    field :rating, :integer, default: 0
    field :title, :string
    field :subtitle, :string, default: ""
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :subtitle, :author, :notes, :pages, :pages_read, :rating, :public])
    |> validate_required([:title, :author, :pages, :pages_read, :rating, :public])
  end
end
