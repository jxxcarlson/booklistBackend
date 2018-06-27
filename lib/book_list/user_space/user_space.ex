defmodule BookList.UserSpace do
  @moduledoc """
  The BookSpace context.
  """

  import Ecto.Query, warn: false
  alias BookList.Repo

  alias BookList.UserSpace.User
  alias BookList.UserSpace.Query

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
    # attrs |> IO.inspect(label: "CREATE USER")
    %User{}
    # |> User.changeset(attrs)
    |> User.registration_changeset(attrs)
    |> Repo.insert()
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

    cond do 
      command == "follow_user" -> BookList.UserSpace.follow_user(user.username, arg)
      command == "unfollow_user" -> BookList.UserSpace.unfollow_user(user.username, arg)
      command == "none" -> user |> User.changeset(attrs) |> Repo.update()
    end
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
    number_of_books = length(Repo.preload(user, :book).book)
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

end
