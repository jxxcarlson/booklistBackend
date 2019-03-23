defmodule BookListWeb.InvitationController do
  use BookListWeb, :controller

  alias BookList.UserSpace
  alias BookList.Repo
  alias BookList.UserSpace.Invitation
  alias BookList.UserSpace.Group

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

#  schema "invitations" do
#    field :invitee, :string
#    field :inviter, :string
#    field :group_name, :string
#    field :group_id, :integer
#    field :status, :string
#
#    timestamps()
#  end

  def accept(conn, params) do
    invitation = Repo.get!(Invitation, params["id"])
    cs_invitation = Invitation.changeset(invitation, %{status: "Accepted"})
    user = UserSpace.Query.get_by_username invitation.invitee
    group = Repo.get(Group, invitation.group_id)
    cs_group = Group.changeset(group, %{members: group.members ++ [invitation.invitee]})
    if cs_invitation.valid? && cs_group.valid? do
      Repo.update(cs_invitation)
      Repo.update(cs_group)
      render(conn, "invitation.json", %{invitation: invitation})
    else
      render("error.json", %{error: "Could not not accept invitation"})
    end
  end

  def reject(conn, params) do
    invitation = Repo.get!(Invitation, params["id"])
    cs_invitation = Invitation.changeset(invitation, %{status: "Rejected"})
    user = UserSpace.Query.get_by_username invitation.invitee

    if cs_invitation.valid? do
      Repo.update(cs_invitation)
      render(conn, "invitation.json", %{invitation: invitation})
    else
      render("error.json", %{error: "Could not reject invitation"})
    end
  end

  def index(conn, params) do
    group_id_ = params["group"]
    invitee = params["invitee"]
    invitations  =
      cond do
          not is_nil(group_id_) ->
            {group_id , _} = Integer.parse group_id_
            Invitation.get_by_id(group_id)
          not is_nil(invitee) ->
            Invitation.get_by_invitee(invitee)
          true -> []
      end
    render(conn, "index.json", invitations: invitations)
  end

end
