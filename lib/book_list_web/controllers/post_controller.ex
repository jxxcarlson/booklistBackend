defmodule BookListWeb.PostController do
  use BookListWeb, :controller

  alias BookList.UserSpace
  alias BookList.Repo
  alias BookList.UserSpace.Post
  alias BookList.UserSpace.Post

  action_fallback BookListWeb.FallbackController


  def create(conn, post_params) do
    IO.inspect post_params, label: "CREATE POST, PARAMS"
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
