defmodule BookList.BookSpace do
  @moduledoc """
  The BookSpace context.
  """

  import Ecto.Query, warn: false
  alias BookList.Repo


  alias BookList.BookSpace.Book

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book)
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{source: %Book{}}

  """
  def change_book(%Book{} = book) do
    Book.changeset(book, %{})
  end

  def update_average_reading_rate(book, p) do
    rr = if round( book.average_reading_rate) == 0  do
            book.pages_read_today
         else
           p*book.average_reading_rate + (1-p)*book.pages_read_today
         end
    IO.puts "rr = #{rr}"
    cs = Book.changeset(book, %{average_reading_rate: rr})
    Repo.update(cs)
  end

  def update_average_reading_rates do
    IO.puts "UPDATE AVERAGE READING RATES"
    books = Repo.all Book
    Enum.map books, (fn (book) -> Book.update_average_reading_rate(book, 0.5) end)

  end
end
