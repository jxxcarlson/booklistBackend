defmodule BookList.UserSpace.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BookList.UserSpace.User
  alias BookList.Repo

  schema "users" do
    field :email, :string
    field :username, :string
    field :firstname, :string, default: "Anon"
    field :lastname, :string, default: "Anon"
    field :password_hash, :string
    field :password, :string, virtual: true
    field :admin, :boolean, default: false
    field :blurb, :string, default: ""
    field :public, :boolean, default: false
    field :follow, {:array, :string}, default: []
    field :followers, {:array, :string}, default: []
    field :tags, {:array, :string}, default: []
    field :reading_stats, {:array, :map}
    field :verified, :boolean, default: false


    timestamps()
  end

  defmodule BookList.UserSpace.User.ReadingStat do
    use Ecto.Schema

    embedded_schema do
      field :date, :utc_datetime
      field :pages_read, :integer
    end
  end


  def pages_read(user) do
    (hd user.reading_stats)["pages_read"]
  end

  # params = %{"reading_stats": [%{"date" => ~D[2019-03-14], "pages_read" => 44}]}
  # cs = User.changeset(u, params)

  @doc false


  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :username, :public,
      :blurb, :email, :password, :password_hash,  :follow, :followers, :tags, :reading_stats, :verified])
    |> validate_required([:firstname, :username, :email])
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



  #  def get_user_id_by_email(email) do
  #    query = from(
  #        user in User,
  #        where: user.email == ^email,
  #        select: user.id
  #   )
  #    Repo.one(query )
  # end

  # def get_user_by_email(email) do
  #    id = get_user_id_by_email(email)
  #    if id == nil do
  #      {:error, "Could not find voter by email"}
  #    else
  #      {:ok, Repo.get(User, id  )}
  #    end
  # end

  def verified_user(user, token) do
    %{user: %{token: token,
      firstName: user.firstname, lastName: user.lastname,
      email: user.email}
    }
  end

end
