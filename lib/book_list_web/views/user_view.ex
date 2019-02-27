defmodule BookListWeb.UserView do
  use BookListWeb, :view
  alias BookListWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "sanitized_user.json")}
  end

  def render("annotated_index.json", %{users: users}) do
    %{data: render_many(users, UserView, "annotated_user.json")}
  end

  def render("public_index.json", %{users: users}) do
    %{data: render_many(users, UserView, "public_user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user, token: token}) do
    %{
      username: user.username,
      id: user.id,
      email: user.email,
      firstname: user.firstname,
      token: token,
      blurb: user.blurb,
      public: user.public || false,
      follow: user.follow || [ ],
      followers: user.followers || [ ],
      admin: user.admin || false
      inserted_at: user.inserted_at
    }
  end

  def render("authenticated.json",  %{user: user, token: token}) do
    %{
      username: user.username,
      id: user.id,
      email: user.email,
      firstname: user.firstname,
      token: token,
      blurb: user.blurb || "",
      public: user.public || false,
      follow: user.follow || [],
      followers: user.followers || [],
      admin: user.admin || false,
      inserted_at: user.inserted_at
    }
  end

  def render("sanitized_user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      firstname: user.firstname,
      token: "fake token",
      blurb: user.blurb || "",
      email: user.email,
      public: user.public || false,
      follow: user.follow || [ ],
      followers: user.followers || [ ],
      admin: user.admin || false
    }
  end

  def render("annotated_user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      firstname: user.firstname,
      token: "fake token",
      blurb: user.blurb || "",
      email: user.email,
      public: user.public || false,
      follow: user.follow || [ ],
      followers: user.followers || [ ],
      admin: user.admin || false,
      numberOfBooks: user.number_of_books || 0
    }
  end

  def render("public_user.json", %{user: user}) do
    %{ username: user.username}
  end

  ###



  def render("error.json", %{error: message}) do
    %{ error: message }
  end

  def render("success.json", %{message: message}) do
    %{ message: message }
  end

  def render("blurb.json", %{blurb: message}) do
    %{ blurb: message }
  end

  def render("reply.json", %{message: message}) do
    %{ message: message }
  end


end
