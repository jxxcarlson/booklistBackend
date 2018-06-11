defmodule BookListWeb.BookView do
  use BookListWeb, :view
  alias BookListWeb.BookView

  def render("index.json", %{books: books}) do
    %{data: render_many(books, BookView, "book.json")}
  end

  def render("show.json", %{book: book}) do
    %{data: render_one(book, BookView, "book.json")}
  end

  def render("book.json", %{book: book}) do
    %{
      title: book.title,
      subtitle: book.subtitle,
      author: book.author,
      notes: book.notes,
      pages: book.pages,
      pagesRead: book.pages_read,
      rating: book.rating
    }
  end
end
