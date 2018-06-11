defmodule BookListWeb.UserController do
  use BookListWeb, :controller

  alias BookList.UserSpace
  alias BookList.UserSpace.User
   alias BookList.UserSpace.Query
  alias BookList.UserSpace.Authentication
  alias BookList.UserSpace.Token 

  action_fallback BookListWeb.FallbackController

  def authenticate(conn, %{"password" => password, "email" => email}) do
      IO.puts "authenticate"
      with {:ok, user} <- Query.get_by_email(email),
        {:ok, _} <- Authentication.checkpw2(password, user.password_hash),
        {:ok, token} <- Token.get(user.id, user.email, 86400*30 )
      do
        # IO.puts "USER AUTHENTICATED"
        render(conn, "verified_user.json", User.    verified_user(user, token))
      else
         # IO.puts "USER NOT AUTHORIZED"
       _ -> render(conn, "error.json", error: "Not authenticated")
      end
      # render(conn, "error.json", error: "YADA YADA")
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

  def show(conn, %{"id" => id}) do
    user = UserSpace.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserSpace.get_user!(id)

    with {:ok, %User{} = user} <- UserSpace.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = UserSpace.get_user!(id)
    with {:ok, %User{}} <- UserSpace.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
