defmodule Kosynierzy.Repo.Migrations.AddWpIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add(:wp_id, :integer)
    end
  end
end
