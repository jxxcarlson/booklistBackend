defmodule BookListWeb.InvitationController do
  use BookListWeb, :controller

  alias BookList.UserSpace
  alias BookList.Repo
  alias BookList.UserSpace.Invitation

  action_fallback BookListWeb.FallbackController


  def invite(conn,  invitation_) do
    invitation = invitation_ |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    cs = Invitation.changeset(%Invitation{}, invitation)
    case cs.valid? do
      true ->
        Repo.insert(cs)
        render(conn, "invitation.json", %{invitation: invitation})
      false ->
        render(conn, "error.json", %{error: "Could not make invitation"})
    end
  end


  def show(conn, %{"id" => id}) do
    invitation = Repo.get!(Invitation, id)
    render(conn, "show.json", invitation: invitation)
  end


  def index(conn, params) do
    group_id_ = params["group"]
    IO.puts "group_id = #{group_id_}"
    invitations  = if group_id_ == nil do
        Repo.all(Invitation)
      else
        {group_id , _} = Integer.parse group_id_
        Invitation.get_by_id(group_id)
    end
    render(conn, "index.json", invitations: invitations)
  end

end
