defmodule BookListWeb.UserController do
  use BookListWeb, :controller

  alias BookList.UserSpace
  alias BookList.UserSpace.User
  alias BookList.UserSpace.Query
  alias BookList.UserSpace.Authentication
  alias BookList.UserSpace.Token

  action_fallback BookListWeb.FallbackController

  def authenticate(conn, %{"password" => password, "email" => email}) do
      with {:ok, user} <- Query.get_by_email(email),
        {:ok, _} <- Authentication.checkpw2(password, user.password_hash),
        {:ok, token} <- Token.get(user.id, user.email, 86400*30 )
      do
         render(conn, "authenticated.json", user: user, token: token)
      else
         _ -> render(conn, "error.json", error: "Not authenticated")
      end
  end

  def index(conn, params) do
    if params["public"] == "YadaBada" do
        render(conn, "index.json", users: UserSpace.list_users())
    else
        render(conn, "public_index.json", users: UserSpace.list_public_users())
    end
  end

  def create(conn, %{"user" => user_params}) do
    user_params |> IO.inspect(label: "user_params")
    with {:ok, username} <- Query.username_is_available(user_params["username"]),
         {:ok, email} <- Query.email_is_available(user_params["email"]),
         {:ok, %User{} = user} <- UserSpace.create_user(user_params) do
              {:ok, token} = Token.get(user.id, user.username)
              conn
              |> put_status(:created)
              |> put_resp_header("location", user_path(conn, :show, user))
              |> render("user.json", %{user: user, token: token})
    else
      err -> render(conn, "reply.json", message: "Error: duplicate email or username")
    end
  end

  def blurb(conn, %{"username" => username}) do
    case BookList.UserSpace.Query.get_by_username(username) do
      {:ok, user} -> render(conn, "blurb.json", blurb: user.blurb)
      {:error, _} -> render(conn, "error.json", error: "user not found")
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserSpace.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserSpace.get_user!(id)
    with {:ok, result} <- Token.authenticated_from_header(conn),
       {:ok, %User{} = user} <- UserSpace.update_user(user, user_params) do
       IO.puts "Update user, good branch"
       render(conn, "reply.json", message: "User updated")
    else
       err -> render(conn, "reply.json", message: "Error: not authorized")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserSpace.get_user!(id)
    with {:ok, result} <- Token.authenticated_from_header(conn),
      {:ok, %User{}} <- UserSpace.delete_user(user) do
      send_resp(conn, :no_content, "")
    else
      err -> render(conn, "reply.json", message: "Error: not authorized")
    end
  end


end
