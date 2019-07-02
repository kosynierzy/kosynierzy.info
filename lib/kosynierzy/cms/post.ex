defmodule Kosynierzy.CMS.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "posts" do
    field :content, :string
    field :slug, :string
    field :title, :string
    field :published, :boolean, virtual: true
    field :published_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published, :published_at])
    |> validate_required([:title, :content])
    |> maybe_update_publication_date()
    |> slugify()
  end

  defp slugify(changeset) do
    case get_change(changeset, :title) do
      nil ->
        changeset

      title ->
        slug =
          :iconv.convert("utf-8", "ascii//translit", title)
          |> String.downcase()
          |> String.replace(~r/[\s-]+/, "-")
          |> String.replace(~r/[^\w-]/, "")

        put_change(changeset, :slug, slug)
    end
  end

  defp maybe_update_publication_date(changeset) do
    case get_change(changeset, :published) do
      true -> maybe_publish(changeset)
      false -> maybe_unpublish(changeset)
      _ -> changeset
    end
  end

  defp maybe_publish(changeset) do
    case changeset |> get_field(:published_at) do
      nil -> put_change(changeset, :published_at, published_timestamp())
      _ -> changeset
    end
  end

  defp maybe_unpublish(changeset) do
    case changeset |> get_field(:published_at) do
      %DateTime{} -> put_change(changeset, :published_at, nil)
      _ -> changeset
    end
  end

  defp published_timestamp do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
  end
end
