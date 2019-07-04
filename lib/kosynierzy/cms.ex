defmodule Kosynierzy.CMS do
  @moduledoc """
  The CMS context.
  """

  require IEx
  import Ecto.Query, warn: false
  alias Kosynierzy.Repo
  alias Kosynierzy.CMS.Article
  alias Kosynierzy.CMS.Comment

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    Repo.all(Article)
  end

  @doc """
  Returns the list of published articles.

  ## Examples

      iex> list_published_articles()
      [%Article{}, ...]

  """
  def list_published_articles(%{"year" => year, "month" => month, "day" => day}) do
    query =
      from a in published_articles_query(),
        where:
          fragment("date_part('year', ?)", a.published_at) == type(^year, :integer) and
            fragment("date_part('month', ?)", a.published_at) == type(^month, :integer) and
            fragment("date_part('day', ?)", a.published_at) == type(^day, :integer)

    Repo.all(query)
  end

  def list_published_articles(%{"year" => year, "month" => month}) do
    query =
      from a in published_articles_query(),
        where:
          fragment("date_part('year', ?)", a.published_at) == type(^year, :integer) and
            fragment("date_part('month', ?)", a.published_at) == type(^month, :integer)

    Repo.all(query)
  end

  def list_published_articles(%{"year" => year}) do
    query =
      from a in published_articles_query(),
        where: fragment("date_part('year', ?)", a.published_at) == type(^year, :integer)

    Repo.all(query)
  end

  def list_published_articles(_) do
    published_articles_query() |> Repo.all()
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id) do
    Repo.get!(articles_with_comments_query(), id) |> Repo.preload(:comments)
  end

  def get_article!(year, month, day, slug) do
    query =
      from a in published_articles_query(),
        where:
          fragment("date_part('year', ?)", a.published_at) == type(^year, :integer) and
            fragment("date_part('month', ?)", a.published_at) == type(^month, :integer) and
            fragment("date_part('day', ?)", a.published_at) == type(^day, :integer)

    query
    |> Repo.get_by!(slug: slug)
    |> Repo.preload(:comments)
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

  iex> update_article(article, %{field: new_value})
  {:ok, %Article{}}

  iex> update_article(article, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Article.

  ## Examples

  iex> delete_article(article)
  {:ok, %Article{}}

  iex> delete_article(article)
  {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

  iex> change_article(article)
  %Ecto.Changeset{source: %Article{}}

  """
  def change_article(%Article{} = article) do
    Article.changeset(article, %{})
  end

  defp published_articles_query do
    from [article: a] in articles_with_comments_query(),
      where: not is_nil(a.published_at),
      order_by: [desc: a.published_at],
      limit: 5
  end

  defp articles_with_comments_query do
    from a in Article,
      as: :article,
      left_join: c in assoc(a, :comments),
      as: :comment,
      select: %{a | comments_count: count(c.id)},
      group_by: a.id
  end

  @doc """
  Returns the list of comments.

  ## Examples

  iex> list_comments()
  [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment) |> Repo.preload(:article)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

  iex> get_comment!(123)
  %Comment{}

  iex> get_comment!(456)
  ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id) |> Repo.preload(:article)

  @doc """
  Creates a comment.

  ## Examples

  iex> create_comment(article, %{user_agent: "foo", ip: "192.168.0.1"}, %{field: value})
  {:ok, %Comment{}}

  iex> create_comment(article, %{user_agent: "", ip: "invalid"}, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_comment(%Article{} = article, %{user_agent: user_agent, ip: ip}, attrs \\ %{}) do
    attrs =
      attrs
      |> Map.put(:user_agent, user_agent)
      |> Map.put(:ip, ip)

    article
    |> Ecto.build_assoc(:comments)
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

  iex> update_comment(comment, %{field: new_value})
  {:ok, %Comment{}}

  iex> update_comment(comment, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

  iex> delete_comment(comment)
  {:ok, %Comment{}}

  iex> delete_comment(comment)
  {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

  iex> change_comment(comment)
  %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
