defmodule BookList.Repo.Migrations.AddBlurbToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do 
      add :blurb, :string
    end

  end
end
