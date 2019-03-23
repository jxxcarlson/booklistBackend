defmodule BookListWeb.GroupController do
  use BookListWeb, :controller

  alias BookList.UserSpace
  alias BookList.UserSpace.Group
  alias BookList.Repo
  alias BookList.UserSpace.Invitation

action_fallback BookListWeb.FallbackController


  def index(conn, params) do
    username = params["user"]
    groups  = if username == nil do
         Repo.all(Group)
       else
         Repo.all Group.with_member(username)
       end
    render(conn, "index.json", groups: groups)
  end

  def create(conn, %{"group" => group_params}) do
    changeset = Group.changeset(%Group{}, group_params)

    case Repo.insert(changeset) do
      {:ok, group} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", group_path(conn, :show, group))
        |> render("show.json", group: group)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BookList.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    group = Repo.get!(Group, id)
    render(conn, "show.json", group: group)
  end

  def update(conn, %{"id" => id, "group" => group_params}) do
    group = Repo.get!(Group, id)
    changeset = Group.changeset(group, group_params)

    case Repo.update(changeset) do
      {:ok, group} ->
        render(conn, "show.json", group: group)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BookList.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    group = Repo.get!(Group, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(group)

    send_resp(conn, :no_content, "")
  end

#  def invite(conn,  invitation) do
#    cs = Invitation.changeset(%Invitation{}, invitation)
#    case cs.valid? do
#      true ->
#        Repo.insert(cs)
#        render(conn, "invitation.json", %{invitation: invitation})
#      false ->
#        render(conn, "error.json", %{error: "Could not make invitation"})
#      end
#  end
#
#  def show_invitation(conn, %{"invitation" => invitation}) do
#    render(conn, "invitation.json", invitation: invitation)
#  end
#
#
#  def invitations(conn, params) do
#    IO.puts "INVITATIONS YAY"
#    IO.inspect params, label: "INVITATIONS"
#    invitations  = Repo.all(Invitation)
#    IO.inspect invitations, label: "INVITATIONS (*)"
#    render(conn, "invitations.json", invitations: invitations)
#  end

end
