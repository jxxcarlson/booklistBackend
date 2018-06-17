defmodule BookListWeb.BookController do
  use BookListWeb, :controller

  alias BookList.BookSpace
  alias BookList.BookSpace.Book
  alias BookList.BookSpace.Query

  action_fallback BookListWeb.FallbackController

  def index(conn, params) do
     IO.inspect params
     books = cond do 
        (params["userid"] || "") != "" -> Query.get_by_user_id params["userid"]
        (params["shared"] || "") != "" -> Query.get_public_by_user_name params["shared"]
        (params["test"] || "") != "xyz111" -> QBookList.BookSpace.list_books() 
        true -> []
     end
    render(conn, "index.json", books: books)
  end

    def index1(conn, params) do
     IO.inspect params
     userid = params["userid"] || ""
     books = if userid == "" do 
       BookList.BookSpace.list_books() 
    else 
       Query.get_by_user_id userid 
    end 
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
