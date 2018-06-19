defmodule BookList.Repo.Migrations.ChangeStringFieldToText do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :blurb, :text
    end

  end
end
