defmodule BookList.Repo.Migrations.AddPosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :text
      add :author_name, :string
      add :group_id, :integer
      add :tags,  {:array, :string}, default: [ ]

      timestamps()
    end
  end
end

