defmodule BookList.Repo.Migrations.AddSubtitleToBook do
  use Ecto.Migration

  def change do
    alter table(:books) do 
      add :subtitle, :string
    end 

  end
end
