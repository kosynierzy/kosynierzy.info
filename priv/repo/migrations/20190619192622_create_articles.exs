defmodule Kosynierzy.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:title, :string, null: false)
      add(:slug, :string)
      add(:content, :text, null: false)
      add(:published_at, :utc_datetime)

      timestamps()
    end

    create(index(:articles, [:slug]))
  end
end
