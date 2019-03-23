defmodule BookListWeb.PostView do

  use BookListWeb, :view
  alias BookListWeb.PostView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      title: post.title || "",
      content: post.content || "",
      author_name: post.author_name || "",
      group_id: post.group_id || -1,
      tags: post.tags || []
    }
  end

  def render("error.json", %{error: str}) do
    %{error: str}
  end



end
