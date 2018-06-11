defmodule BookList.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :firstname, :string
      add :lastname, :string
      add :password_hash, :string 
      add :admin, :boolean

      timestamps()
    end

  end
end


