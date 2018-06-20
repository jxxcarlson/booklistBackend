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

  def index(conn, _params) do
    users = UserSpace.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- UserSpace.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
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
