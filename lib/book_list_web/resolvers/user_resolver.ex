defmodule BookListWeb.Resolvers.UserResolver do
  @moduledoc false

  alias BookList.UserSpace
  alias  BookList.UserSpace.Query
  alias BookList.UserSpace.User
  alias BookList.Repo


  def get_user(_root, %{id: id}, _resolution) do
   u = Repo.get(User, id)
  {:ok, fix_user(u)}
  end

  def list_users(_root, _args, _info) do
    users = UserSpace.list_users()
    {:ok, users}
  end


  def fix_user(user) do
    new_reading_stats = Enum.map  user.reading_stats, (fn(stat) -> map_keys_to_atoms(stat) end)
    new_user = %{ user | reading_stats: new_reading_stats }
  end

  # Implementation based on: http://stackoverflow.com/a/31990445/175830
  def map_keys_to_atoms(map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end

  def map_keys_to_strings(map) do
    for {key, val} <- map, into: %{}, do: {Atom.to_string(key), val}
  end

end
