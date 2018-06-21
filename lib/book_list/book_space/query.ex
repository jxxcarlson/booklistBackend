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

  def is_public(query) do
    from b in query,
      where: b.public == ^true
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

  def get_public_by_user_name(username) do
    user =  BookList.UserSpace.Query.get_by_username(username) |> IO.inspect(label: "(1)")
    if user == nil do
      []
    else
      Book
        |> by_user_id(user.id)
        |> IO.inspect(label: "(2)")
        |> is_public
        |> IO.inspect(label: "(3)")
        |> sort_by_last_modified
        |> IO.inspect(label: "(4)")
        |> Repo.all
    end
  end

  def get_public_by_email(email) do
    user =  BookList.UserSpace.Query.get_by_email(email)
    if user == nil do
      []
    else
      Book
        |> by_user_id(user.id)
        |> is_public
        |> sort_by_last_modified
        |> Repo.all
    end
  end

  def get(id) do
    Book |> by_id(id) |> Repo.one
  end


end
