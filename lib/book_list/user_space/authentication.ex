defmodule BookList.UserSpace.Authentication do

  @moduledoc """
  The boundary for the Authentication system. It manages
  user registration and authentication: a registered user
  can present email and password to receive a JWTtoken that
  grants access to the system.  A user can then create documents
  (of which he will be the author/owner), as well as list,read, edit,
  and delete them.  User actions run through /api/users and document
  actions through /api/documents.  Documents which carry the attribute
  public: true may be listed and read through the /api/public/documents
  route.

  NOTE:

  """


  import Ecto.Query, warn: false
  import Comeonin.Bcrypt, only: [checkpw: 2]
  import Ecto.Changeset

  alias BookList.UserSpace.User
  alias BookList.UserSpace.Query
  alias BookList.UserSpace.Randomizer
  alias BookList.UserSpace.Token
  alias BookList.Repo

# alias Vbuddy.Randomizer

  def generate_password do
    [Randomizer.randomizer(3, :upcase), Randomizer.randomizer(3, :numeric), Randomizer.randomizer(3, :upcase)]
    |> Enum.join("-")
  end

  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(_query_string) do
    User |> Query.sort_by_username |> Repo.all
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


  def email_is_valid(email) do
    cond do
      String.contains?(email, "@")-> {:ok, email}
      true -> {:error, "#{email} is an invalid email address"}
    end
  end

  def email_is_available(email) do
    case Query.get_by_email(email) do
      {:ok, user} -> {:error, "Email address #{email} is taken"}
      {:error, _} -> {:ok, email}
    end
  end

  def username_is_available(username) do
    case Query.get_by_username(username) do
      {:ok, user} -> {:error, "Username #{username} is taken"}
      {:error, _} -> {:ok, username}
    end
  end

  def user_available(username, email) do
    username = username || ""
    email = email || ""
    errors = []
    with  {:ok, email} <- email_is_valid(email),
      {:ok, email} <- email_is_available(email),
      {:ok, username} <- username_is_available(username)
    do
      {:ok, [username, email]}
    else
      err -> err
    end
  end


  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
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
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  # def minimal_update_user(%User{} = user, attrs) do
  #   user
  #   |> User.minimal_changeset(attrs)
  #   |> Repo.update()
  # end

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



#################################

  @doc """
  Authentication.get_token(%{"email" => "h12gg@foo.io", "password" => "yada+yada"}) ==
  {:ok, "aaa.bbb.ccc", "joe23"} if the request is valid.  Here "aaa.bbb.ccc" is the
  authentication token and "joe23" is the username.

  If the request is invalid, then {:error, "Incorrect password or email"} is returned.
  """
  def get_token(params \\ %{}) do
    with  {:ok, user} <- get_user(params["email"]),
          {:ok, _} <- checkpw2(params["password"], user.password_hash),
          {:ok, token} <- Token.get(user.id, user.username)
    do
      {:ok, token, user.username}
    else
      {:error, _} -> {:error, "Incorrect username (email) or password"}
    end
  end

  defp get_user(nil), do: {:error, "email is required"}

  defp get_user(email) do
    user =  Repo.get_by(User, email: email)
    case user do
     nil -> {:error, "User not found"}; IO.puts "USER NOT FOUND"
     _ -> {:ok, user}; IO.puts "GO USER"
    end
  end

  def checkpw2(password, password_hash) do
    if  checkpw(password, password_hash) == true do
      IO.puts "Password OK"
      {:ok, true}
    else
      IO.puts "Password INVALID"
      {:error, "Incorrect password or email"}
    end
  end



end
