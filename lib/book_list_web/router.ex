defmodule BookListWeb.Router do
  use BookListWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  resources "/api/users", BookListWeb.UserController #, except: [:new, :edit]
  post "/api/users/authenticate", BookListWeb.UserController, :authenticate
  get "/api/blurb/:username", BookListWeb.UserController, :blurb
  resources "/api/books", BookListWeb.BookController
  resources "/api/groups", BookListWeb.GroupController
  resources "/stats", StatController, except: [:new, :edit]

  scope "/api", BookListWeb do
    pipe_through :api
  end
end
