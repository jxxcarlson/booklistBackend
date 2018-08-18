defmodule BookList.BookSpace.Book do
  use Ecto.Schema
  import Ecto.Changeset


  schema "books" do
    field :author, :string
    field :notes, :string, default: "Just started."
    field :category, :string, default: ""
    field :pages, :integer, default: 10
    field :pages_read, :integer, default: 0
    field :public, :boolean, default: false
    field :rating, :integer, default: 0
    field :title, :string
    field :subtitle, :string, default: ""
    field :user_id, :id
    field :start_date_string, :string, default: ""
    field :finish_date_string, :string, default: ""

    # belongs_to :user, BookList.UserSpace.User  
    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:user_id, :title, :subtitle, :author, :notes, :pages, :pages_read, 
       :rating, :public, :category, :start_date_string, :finish_date_string])
    |> validate_required([:title, :author, :pages, :pages_read, :rating, :public])
  end
end
