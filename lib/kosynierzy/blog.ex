defmodule Kosynierzy.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Kosynierzy.Repo

  alias Kosynierzy.Blog.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Returns the list of published posts.

  ## Examples

      iex> list_published_posts()
      [%Post{}, ...]

  """
  def list_published_posts(%{"year" => year, "month" => month, "day" => day}) do
    query =
      from p in Post,
        where:
          fragment("date_part('year', ?)", p.published_at) == type(^year, :integer) and
            fragment("date_part('month', ?)", p.published_at) == type(^month, :integer) and
            fragment("date_part('day', ?)", p.published_at) == type(^day, :integer)

    Repo.all(query)
  end

  def list_published_posts(%{"year" => year, "month" => month}) do
    query =
      from p in Post,
        where:
          fragment("date_part('year', ?)", p.published_at) == type(^year, :integer) and
            fragment("date_part('month', ?)", p.published_at) == type(^month, :integer)

    Repo.all(query)
  end

  def list_published_posts(%{"year" => year}) do
    query =
      from p in Post,
        where: fragment("date_part('year', ?)", p.published_at) == type(^year, :integer)

    Repo.all(query)
  end

  def list_published_posts(_) do
    query = from p in Post, where: not is_nil(p.published_at)

    Repo.all(query)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end
end
