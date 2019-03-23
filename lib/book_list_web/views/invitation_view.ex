defmodule BookListWeb.InvitationView do

  use BookListWeb, :view
  alias BookListWeb.InvitationView

  def render("index.json", %{invitations: invitations}) do
    %{data: render_many(invitations, InvitationView, "invitation.json")}
  end

  def render("show.json", %{invitation: invitation}) do
    %{data: render_one(invitation, InvitationView, "invitation.json")}
  end

  def render("invitation.json", %{invitation: invitation}) do
    %{id: invitation.id,
     invitee: invitation.invitee,
      inviter: invitation.inviter || "",
      group_name: invitation.group_name || "",
      status: invitation.status || "",
      group_id: invitation.group_id || -1
    }
  end

  def render("error.json", %{error: str}) do
    %{error: str}
  end

  def render("reply.json", %{reply: str}) do
    %{reply: str}
  end

end
