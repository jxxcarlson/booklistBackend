defmodule BookListWeb.Router do
  use BookListWeb, :router

  alias BookListWeb.PasswordController
  alias BookListWeb.MailController

  pipeline :api do
    plug :accepts, ["json"]
  end

  resources "/api/users", BookListWeb.UserController #, except: [:new, :edit]
  post "/api/users/authenticate", BookListWeb.UserController, :authenticate
  get "/api/blurb/:username", BookListWeb.UserController, :blurb
  resources "/api/books", BookListWeb.BookController
  resources "/api/groups", BookListWeb.GroupController
  resources "/stats", BookListWeb.StatController, except: [:new, :edit]
  get "/api/stats/last", BookListWeb.StatController, :last

  get "/api/password/request", PasswordController, :show_request_form
  get "/api/password/mail_reset_link", PasswordController, :mail_reset_link
  get "/api/password/form", PasswordController, :show_reset_form
  get "/api/password/reset", PasswordController, :reset_password

  post "/api/mail", MailController, :mail
  get "/api/verify/:token", BookListWeb.UserController, :verify

  post "/api/groups/invite", BookListWeb.GroupController, :invite

  scope "/api", BookListWeb do
    pipe_through :api
  end
end
