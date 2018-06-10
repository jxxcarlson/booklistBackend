defmodule BookListWeb.BookController do
  use BookListWeb, :controller

  alias BookList.BookSpace
  alias BookList.BookSpace.Book

  action_fallback BookListWeb.FallbackController

  def index(conn, _params) do
    books = BookSpace.list_books()
    render(conn, "index.json", books: books)
  end

  def create(conn, %{"book" => book_params}) do
    with {:ok, %Book{} = book} <- BookSpace.create_book(book_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", book_path(conn, :show, book))
      |> render("show.json", book: book)
    end
  end

  def show(conn, %{"id" => id}) do
    book = BookSpace.get_book!(id)
    render(conn, "show.json", book: book)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = BookSpace.get_book!(id)

    with {:ok, %Book{} = book} <- BookSpace.update_book(book, book_params) do
      render(conn, "show.json", book: book)
    end
  end

  def delete(conn, %{"id" => id}) do
    book = BookSpace.get_book!(id)
    with {:ok, %Book{}} <- BookSpace.delete_book(book) do
      send_resp(conn, :no_content, "")
    end
  end
end
