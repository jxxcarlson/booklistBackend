defmodule BookListWeb.Router do
  use BookListWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  resources "/users", UserController #, except: [:new, :edit]
  resources "/books", BookController

  scope "/api", BookListWeb do
    pipe_through :api
  end
end
