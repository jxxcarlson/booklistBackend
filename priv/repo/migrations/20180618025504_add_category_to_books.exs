defmodule BookList.Repo.Migrations.AddCategoryToBooks do
  use Ecto.Migration

  def change do
    alter table(:books) do 
      add :category, :string
    end

  end
end
