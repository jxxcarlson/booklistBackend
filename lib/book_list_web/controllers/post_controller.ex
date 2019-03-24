defmodule BookListWeb.PostController do
  use BookListWeb, :controller

  alias BookList.UserSpace
  alias BookList.Repo
  alias BookList.UserSpace.Post
  alias BookList.UserSpace.Post
  alias BookList.UserSpace.Token

  action_fallback BookListWeb.FallbackController


  def create(conn, post_params) do
    with {:ok, result} <- Token.authenticated_from_header(conn) do
      changeset = Post.changeset(%Post{}, post_params)

      case Repo.insert(changeset) do
        {:ok, post} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", post_path(conn, :show, post))
          |> render("show.json", post: post)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(BookList.ChangesetView, "error.json", changeset: changeset)
      end
    else
      err -> render(conn, "reply.json", message: "Error: not authorized")
    end
  end

  def update(conn, post_params) do
    with {:ok, result} <- Token.authenticated_from_header(conn) do
      post = Repo.get!(Post, post_params["id"])
      changeset = Post.changeset(post, post_params)

      case Repo.update(changeset) do
        {:ok, post} ->
          render(conn, "show.json", post: post)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(BookList.ChangesetView, "error.json", changeset: changeset)
      end
    else
      err -> render(conn, "reply.json", message: "Error: not authorized")
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, result} <- Token.authenticated_from_header(conn) do
      post = Repo.get!(Post, id)
      Repo.delete!(post)
      send_resp(conn, :no_content, "")
    else
      err -> render(conn, "reply.json", message: "Error: not authorized")
    end

  end
  
  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    render(conn, "show.json", post: post)
  end

  def index(conn, params) do
    group_id_ = params["group"]
    posts  =
      cond do
        not is_nil(group_id_) ->
          {group_id , _} = Integer.parse group_id_
          Post.get_by_group_id(group_id)
        true -> []
      end
    render(conn, "index.json", posts: posts)
  end

end
