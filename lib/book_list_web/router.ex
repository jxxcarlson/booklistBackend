defmodule BookListWeb.Router do
  use BookListWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  resources "/api/users", BookListWeb.UserController #, except: [:new, :edit]
  post "/api/users/authenticate", BookListWeb.UserController, :authenticate
  
  resources "/api/books", BookListWeb.BookController
  

  scope "/api", BookListWeb do
    pipe_through :api
  end
end
