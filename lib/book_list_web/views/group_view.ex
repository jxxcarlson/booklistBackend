defmodule BookListWeb.GroupView do

  use BookListWeb, :view
  alias BookListWeb.GroupView

  def render("index.json", %{groups: groups}) do
    %{data: render_many(groups, GroupView, "group.json")}
  end

  def render("show.json", %{group: group}) do
    %{data: render_one(group, GroupView, "group.json")}
  end

  def render("group.json", %{group: group}) do
    %{id: group.id,
      name: group.name || "",
      chair: group.chair || "",
      cochair: group.cochair || "",
      blurb: group.blurb || "",
      members: group.members || []
    }
  end
#
#
#  def render("invitations.json", %{invitations: invitations}) do
#    IO.inspect invitations, label: "INVITATIONS (2)"
#    %{data: render_many(invitations, GroupView, "invitation1.json")}
#  end
#
#  def render("invitation1.json", %{group: invitation}) do
#    %{invitee: invitation["invitee"],
#      inviter: invitation["inviter"] || "",
#      group_name: invitation["group_name"] || "",
#      status: invitation["status"] || "",
#      group_id: invitation["group_id"] || -1
#    }
#  end
#
#  def render("invitation.json", %{invitation: invitation}) do
#    %{invitee: invitation["invitee"],
#      inviter: invitation["inviter"] || "",
#      group_name: invitation["group_name"] || "",
#      status: invitation["status"] || "",
#      group_id: invitation["group_id"] || -1
#    }
#  end


  def render("error.json", %{error: str}) do
    %{error: str}
  end



end
