defmodule Kosynierzy.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:article_id, references(:articles, on_delete: :delete_all), null: false)
      add(:content, :text)
      add(:author, :string)
      add(:author_email, :string)
      add(:url, :string)
      add(:ip, :cidr, null: false)
      add(:user_agent, :text)

      timestamps(updated_at: false)
    end
  end
end
