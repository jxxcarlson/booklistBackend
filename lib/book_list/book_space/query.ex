defmodule BookList.BookSpace.Query do

  import Ecto.Query
  alias BookList.BookSpace.Book
  alias BookList.Repo


  ## QUERIES

  def by_username(query, username) do
    from b in query,
      where: b.username == ^username
  end

  def by_id(query, id) do
    from b in query,
      where: b.id == ^id
  end

  def by_user_id(query, user_id) do
    from b in query,
      where: b.user_id == ^user_id
  end


  def sort_by_username(query) do
      from b in query,
        order_by: [asc: b.username]
  end

  def sort_by_last_modified(query) do
      from b in query,
        order_by: [desc: b.updated_at]
  end

    def sort_by_title(query) do
      from b in query,
        order_by: [asc: b.title]
  end


  ## GET BOOKS



  def get_by_user_id(user_id) do
    Book |> by_user_id(user_id) |> sort_by_last_modified |> Repo.all
  end

  def get(id) do
    Book |> by_id(id) |> Repo.one
  end


end
