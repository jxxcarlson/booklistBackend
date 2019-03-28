defmodule BookListWeb.Resolvers.GroupResolver do
  @moduledoc false

  alias BookList.UserSpace.Group
  alias BookList.Repo


  def list_groups(_root, _args, _info) do
    groups = Repo.all Group
    {:ok, groups}
  end


end
