defmodule BookListWeb.UserView do
  use BookListWeb, :view
  alias BookListWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email}
  end

  ###

  def render("authenticated.json",  %{username: username, token: token}) do
    %{
      username: username,
      token: token
    }
  end

  def render("error.json", %{error: message}) do
    %{ error: message }
  end

  def render("success.json", %{message: message}) do
    %{ message: message }
  end


end
