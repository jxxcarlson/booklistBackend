defmodule BookListWeb.GroupView do
  use BookListWeb, :view

  def render("index.json", %{groups: groups}) do
    %{data: render_many(groups, BookList.GroupView, "group.json")}
  end

  def render("show.json", %{group: group}) do
    %{data: render_one(group, BookList.GroupView, "group.json")}
  end

  def render("group.json", %{group: group}) do
    %{id: group.id,
      name: group.name,
      chair: group.chair,
      cochair: group.cochair,
      blurb: group.blurb}
  end
end
