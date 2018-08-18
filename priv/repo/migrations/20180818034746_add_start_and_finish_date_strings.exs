defmodule BookList.Repo.Migrations.AddStartAndFinishDateStrings do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :start_date_string, :string, default: ""
      add :finish_date_string, :string, default: ""
    end
  end
end
