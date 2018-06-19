defmodule BookList.Repo.Migrations.NoteChangeStringFieldToText do
  use Ecto.Migration

  def change do
    alter table(:books) do
      modify :notes, :text
    end

  end
end
