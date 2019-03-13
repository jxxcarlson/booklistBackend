defmodule BookList.BookSpace.Stat do
  # use BookList.Web, :model

  use Ecto.Schema
  import Ecto.Changeset
  alias BookList.BookSpace.Book
  alias BookList.UserSpace.User
  alias BookList.Repo
  alias BookList.BookSpace.Stat


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


  def book_stats() do
    books = Repo.all(Book)
    number_of_books = Enum.count books
    books_read = Enum.filter books, (fn(b) -> b.finish_date_string != "" end)
    number_of_books_read = Enum.count books_read
    number_of_pages = Enum.sum (Enum.map books, (fn(b) -> b.pages end))
    number_of_pages_read = Enum.sum (Enum.map books, (fn(b) -> b.pages_read end))
    [number_of_books, number_of_pages,number_of_books_read, number_of_pages_read ]
  end

  def user_stats() do
    users = Repo.all(User)
    Enum.count users
  end

  def create do
    users = user_stats
    [books, pages, books_read, pages_read] = book_stats
    cs = changeset(%Stat{}, %{"users": users, "books": books, "books_read": books_read, "pages": pages, "pages_read": pages_read })
    Repo.insert(cs)
  end


end
