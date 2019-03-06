defmodule :"Elixir.BookList.Repo.Migrations.Add user tags" do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :tags, {:array, :string}
    end
  end
end
