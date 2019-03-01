defmodule BookListWeb.BookController do
  use BookListWeb, :controller

  alias BookList.BookSpace
  alias BookList.BookSpace.Book
  alias BookList.BookSpace.Query
  alias BookList.UserSpace.Token

  action_fallback BookListWeb.FallbackController

  def index(conn, params) do
     IO.inspect params
     books = cond do
        (params["userid"] || "") != "" -> Query.get_by_user_id params["userid"]
        (params["shared"] || "") != "" -> get_shared_books(params["shared"])
        true -> []
     end
    render(conn, "index.json", books: books)
  end

  def get_shared_books(key) do
    if String.contains? key, "@" do
      Query.get_public_by_email key
    else
      Query.get_public_by_user_name key
    end
  end

  def create(conn, %{"book" => book_params}) do
    IO.puts "CREATE BOOK"
    with {:ok, result} <- Token.authenticated_from_header(conn),
      {:ok, %Book{} = book} <- BookSpace.create_book(book_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", book_path(conn, :show, book))
          |> render("show.json", book: book)
    else
          err -> render(conn, "reply.json", message: "Error: not authorized")
    end
  end

  def show(conn, %{"id" => id}) do
    book = BookSpace.get_book!(id)
    render(conn, "show.json", book: book)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    book = BookSpace.get_book!(id)
    with {:ok, result} <- Token.authenticated_from_header(conn),
      {:ok, %Book{} = book} <- BookSpace.update_book(book, book_params) do
      render(conn, "show.json", book: book)
    else
      err -> render(conn, "reply.json", message: "Error: not authorized")
    end
  end

  def delete(conn, %{"id" => id}) do
    book = BookSpace.get_book!(id)
    with {:ok, result} <- Token.authenticated_from_header(conn),
      {:ok, %Book{}} <- BookSpace.delete_book(book) do
      send_resp(conn, :no_content, "")
    else
      err -> render(conn, "reply.json", message: "Error: not authorized")
    end
  end
end
