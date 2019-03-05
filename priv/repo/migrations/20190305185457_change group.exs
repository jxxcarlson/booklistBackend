defmodule :"Elixir.BookList.Repo.Migrations.Change group" do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      remove :firstName
      add :name, :string
    end
  end
end
