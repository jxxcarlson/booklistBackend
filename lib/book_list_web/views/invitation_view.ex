defmodule BookListWeb.InvitationView do

  use BookListWeb, :view
  alias BookListWeb.InvitationView


  def render("invitation.json", %{invitation: invitation}) do
    %{invitee: invitation.invitee,
      inviter: invitation.inviter || "",
      group_name: invitation.group_name || "",
      status: invitation.status || "",
    }
  end



end
