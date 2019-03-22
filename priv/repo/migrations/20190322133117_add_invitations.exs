defmodule BookList.Repo.Migrations.AddInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :invitee, :string
      add :inviter, :string
      add :group_name, :string
      add :group_id, :integer
      add :status, :string

      timestamps()
    end
  end
end
