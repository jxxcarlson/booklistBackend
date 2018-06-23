defmodule BookList.Repo.Migrations.AddFollowedArrayToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :follow, {:array, :integer}
    end
  end
end
