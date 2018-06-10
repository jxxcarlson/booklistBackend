defmodule BookListWeb.UserController do
  use BookListWeb, :controller

  alias BookList.BookSpace
  alias BookList.BookSpace.User

  action_fallback BookListWeb.FallbackController

  def index(conn, _params) do
    users = BookSpace.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- BookSpace.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = BookSpace.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = BookSpace.get_user!(id)

    with {:ok, %User{} = user} <- BookSpace.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = BookSpace.get_user!(id)
    with {:ok, %User{}} <- BookSpace.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
