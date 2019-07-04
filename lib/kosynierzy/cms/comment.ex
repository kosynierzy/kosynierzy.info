defmodule Kosynierzy.CMS.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kosynierzy.CMS.Article

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_fields [:content, :author, :author_email, :user_agent, :ip]
  @optional_fields [:url]

  schema "comments" do
    field :author, :string
    field :author_email, :string
    field :content, :string
    field :ip, EctoNetwork.CIDR
    field :url, :string
    field :user_agent, :string

    belongs_to :article, Article

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
