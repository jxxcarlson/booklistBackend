defmodule BookListWeb.Resolvers.BookResolver do
  @moduledoc false

  alias BookList.BookSpace
  alias  BookList.BookSpace.Query


  def list_books(_root, %{user_id: user_id}, _resolution) do
    IO.puts "LIST BOOKS (1)"
    {:ok, Query.get_by_user_id(user_id)}
  end

  def list_books(_root, _args, _info) do
    IO.puts "LIST BOOKS (2)"
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
