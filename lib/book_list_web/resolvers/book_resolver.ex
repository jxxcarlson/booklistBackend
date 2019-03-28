defmodule BookListWeb.Resolvers.BookResolver do
  @moduledoc false

  alias BookList.BookSpace

  def all_books(_root, _args, _info) do
    books = BookSpace.list_books()
    {:ok, books}
  end

  def create_book(_root, args, _info) do
    # TODO: add detailed error message handling later
    case BookSpace.create_book(args) do
      {:ok, book} ->
        {:ok, book}
      _error ->
        {:error, "could not create book"}
    end
  end


end
