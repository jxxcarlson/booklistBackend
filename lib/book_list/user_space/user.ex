defmodule BookList.UserSpace.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BookList.UserSpace.User
  alias BookList.Repo

  schema "users" do
    field :email, :string
    field :username, :string
    field :firstname, :string
    field :lastname, :string 
    field :password_hash, :string
    field :password, :string, virtual: true
    field :admin, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset1(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :username, :email, :password, :password_hash])
    |> validate_required([:firstname, :lastname, :username, :email])
  end

  def registration_changeset(%User{} = user, params \\ :empty) do
    user
    |> changeset(params)
    |> cast(params, ~w(password))
    #|> validate_length(:password, min: 6)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end


  def get_user(id) do
    result = Repo.get(User, id)
    case result do
      nil -> {:error, "request for user #{id} failed"}
      _ -> {:ok, result}
    end
  end

end

