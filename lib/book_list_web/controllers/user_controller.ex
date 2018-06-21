defmodule BookListWeb.UserController do
  use BookListWeb, :controller

  alias BookList.UserSpace
  alias BookList.UserSpace.User
  alias BookList.UserSpace.Query
  alias BookList.UserSpace.Authentication
  alias BookList.UserSpace.Token

  action_fallback BookListWeb.FallbackController

  def authenticate(conn, %{"password" => password, "email" => email}) do
      with user <- Query.get_by_email(email),
        {:ok, _} <- Authentication.checkpw2(password, user.password_hash),
        {:ok, token} <- Token.get(user.id, user.email, 86400*30 )
      do
         render(conn, "authenticated.json", user: user, token: token)
      else
         _ -> render(conn, "error.json", error: "Not authenticated")
      end
  end

  def index1(conn, _params) do
    users = UserSpace.list_users()
    render(conn, "index.json", users: users)
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
              IO.puts "user id = #{user.id}"
              IO.puts "username = #{user.username}"
              {:ok, token} = Token.get(user.id, user.username)
              IO.puts "token = #{token}"
              conn
              |> put_status(:created)
              |> put_resp_header("location", user_path(conn, :show, user))
              |> render("user.json", %{user: user, token: token})
    else
      err -> render("reply.json", message: "Error: duplicate email or username")
    end
  end

  def blurb(conn, %{"username" => username}) do
    user = BookList.UserSpace.Query.get_by_username(username)
    if user != nil do
      IO.puts "blurb, user = #{user.firstname}"
      render(conn, "blurb.json", blurb: user.blurb)
    else
      IO.puts "ERROR (DT)"
      render(conn, "error.json", error: "user not found")
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserSpace.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserSpace.get_user!(id)

    with {:ok, %User{} = user} <- UserSpace.update_user(user, user_params) do
      render(conn, "reply.json", message: "User updated")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserSpace.get_user!(id)
    with {:ok, %User{}} <- UserSpace.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
