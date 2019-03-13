defmodule BookListWeb.StatView do
  use BookListWeb, :view

  def render("index.json", %{stats: stats}) do
    %{data: render_many(stats, BookList.StatView, "stat.json")}
  end

  def render("show.json", %{stat: stat}) do
    %{data: render_one(stat, BookList.StatView, "stat.json")}
  end

  def render("stat.json", %{stat: stat}) do
    %{id: stat.id,
      users: stat.users,
      books: stat.books,
      books_read: stat.books_read,
      pages: stat.pages,
      pages_read: stat.pages_read}
  end
end
