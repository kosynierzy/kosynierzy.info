defmodule Kosynierzy.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "posts" do
    field :content, :string
    field :title, :string
    field :published, :boolean, virtual: true
    field :published_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published_at])
    |> validate_required([:title, :content])
  end
end
