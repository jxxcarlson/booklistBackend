defmodule BookList.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :author, :string
      add :notes, :text
      add :pages, :integer
      add :pages_read, :integer
      add :rating, :integer
      add :public, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:books, [:user_id])
  end
end
