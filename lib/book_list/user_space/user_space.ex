defmodule BookList.UserSpace do
  @moduledoc """
  The BookSpace context.
  """

  import Ecto.Query, warn: false
  alias BookList.Repo

  alias BookList.UserSpace.User
  alias BookList.UserSpace.Query
  alias BookList.UserSpace

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User |> Query.sort_by_username |> Repo.all
  end

  def list_public_users do
    User |> Query.is_public |> Query.sort_by_username |> Repo.all
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    new_attrs = Map.merge initialReadingStat, attrs

    # attrs |> IO.inspect(label: "CREATE USER")
    %User{}
    # |> User.changeset(attrs)
    |> User.registration_changeset(new_attrs)
    |> Repo.insert()
  end

  def initialReadingStat do
    today = Date.utc_today
    today_string = Date.to_iso8601(today)
    y = today.year
    m = today.month - 1
    if m < 0 do
      m = 12
      y = y - 1
    end
    {:ok, date} = Date.new(y,m,28)
    dateString = Date.to_iso8601(date)
    %{"reading_stats" =>  [
        %{"date" => today_string, "pages_read" => 0},
        %{"date" => dateString, "pages_read" => 0}
       ]
     }
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs, query_string) do
    [command, arg] = (if query_string == "" || (not (String.contains? query_string, "=")) do
                        "none=none"
                      else
                        query_string
                      end) |> String.split "="

    IO.puts "command = #{command}"
    IO.puts "arg = #{arg}"
    attrs |> IO.inspect(label: "XX ATTRS")

    cs = User.changeset(user, attrs) |> IO.inspect(label: "XX CS")
    cond do
      command == "follow_user" -> BookList.UserSpace.follow_user(user.username, arg)
      command == "unfollow_user" -> BookList.UserSpace.unfollow_user(user.username, arg)
      # command == "none" -> user |> User.changeset(attrs) |> Repo.update()
      command == "none" -> Repo.update(cs)
    end

    # user |> User.changeset(attrs) |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def follow_user(username, followed_user_name) do
    with {:ok, user} <- Query.get_by_username(username),
      {:ok, followed_user} <- Query.get_by_username(followed_user_name)
    do
      # Add followed user to user
      users_i_follow = (user.follow || [ ]) ++ [followed_user_name]
      users_i_follow |> IO.inspect(label: "XXX: users I (#{username} I follow")
      cs = User.changeset(user, %{follow: users_i_follow})
      Repo.update(cs)

      # Add user as follower of followed user
      followers = (followed_user.followers || [ ]) ++ [username]
      followers |> IO.inspect(label: "XXX: followers of #{followed_user.username}")
      cs2 = User.changeset(followed_user, %{followers: followers})
      Repo.update(cs2)

    end
  end

  def unfollow_user(username, followed_user_name) do
    with {:ok, user} <- Query.get_by_username(username),
      {:ok, followed_user} <- Query.get_by_username(followed_user_name)
    do
      # Remove followed user from user
      users_i_follow = (user.follow || [ ]) |> Enum.filter(fn(name) -> name != followed_user_name end)
      cs = User.changeset(user, %{follow: users_i_follow})
      Repo.update(cs)

      # Remove user as follower of followed user
      followers = (followed_user.followers || [ ]) |> Enum.filter(fn(name) -> name != username end)
      cs = User.changeset(followed_user, %{followers: followers})
      Repo.update(cs)
    end
  end

  def annotated_user(user) do
    number_of_books = User.pages_read(user)
    Map.merge user, %{number_of_books: number_of_books}
  end

  def list_annotated_users do
    User
      |> BookList.UserSpace.Query.sort_by_username
      |> Repo.all
      |> Enum.map(fn(u) -> annotated_user(u) end)
  end

  # uu = User |> BookList.UserSpace.Query.sort_by_username |> Repo.all
  # ll = uu |> Enum.map(fn(u) -> length(Repo.preload(u, :book).book) end)
  # vv = Enum.zip uu, ll

  def last_reading_stat(user) do
    stat = user.reading_stats |> hd
    {:ok, date} = stat["date"] |> Date.from_iso8601
    %{"date": date, "pages_read": stat["pages_read"]}
  end

  def parts_of_date_string(date_string) do
    String.split date_string, "-"
  end


  def pages_read(user) do
    books = BookList.BookSpace.Query.get_by_user_id(user.id)
    Enum.sum (Enum.map books, (fn(b) -> b.pages_read end))
  end


  def updated_reading_stats(user, date, pages_read) do

    date_string = date |> Date.to_iso8601
    reading_stats = user.reading_stats
    if reading_stats == []  do
      [%{"date" => date_string, "pages_read" => pages_read} ]
    else
      updated_reading_stats_helper(user, date, pages_read)
    end

  end


  def updated_reading_stats_helper(user, date, pages_read) do

    reading_stats = user.reading_stats
    [last_stat | remaining_stats] = reading_stats


    [y, m, d] = parts_of_date_string last_stat["date"]

    date_string = date |> Date.to_iso8601
    [y1, m1, d1] = date_string |> parts_of_date_string

    if y == y1 && m == m1 do
      [%{"date" => date_string, "pages_read" => pages_read} |remaining_stats]
    else
      [%{"date" => date_string, "pages_read" =>  pages_read} | reading_stats]
    end

  end

  def update_reading_stats(user, date) do
    new_reading_stats = updated_reading_stats(user, date, UserSpace.pages_read(user))
    cs = User.changeset(user, %{"reading_stats": new_reading_stats})
    Repo.update(cs)

  end

  def fixstats(id) do
    user = Repo.get(User, id)
    head_stat =  user.reading_stats |> hd
    updated_stats = [head_stat, %{"date" => "2019-02-28", "pages_read" => 0} ]
    params = %{"reading_stats": updated_stats}
    cs = User.changeset(user, params)
    Repo.update(cs)
  end

  def zerostats(id) do
    user = Repo.get(User, id)
    updated_stats = [ ]
    params = %{"reading_stats": updated_stats}
    cs = User.changeset(user, params)
    Repo.update(cs)
  end

end
