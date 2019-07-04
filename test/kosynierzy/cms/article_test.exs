defmodule Kosynierzy.CMS.ArticleTest do
  use Kosynierzy.DataCase

  import Kosynierzy.Factory

  alias Kosynierzy.CMS
  alias Kosynierzy.CMS.Article

  # doctest CMS

  @valid_attrs %{title: "Blog article", content: "Blog content"}
  @update_attrs %{title: "Updated article", content: "Updated content"}
  @invalid_attrs %{title: "", content: "", published: ""}

  describe "list_articles/0" do
    setup [:create_draft, :create_article]

    test "returns all articles", %{draft: draft, article: article} do
      assert CMS.list_articles() == [draft, article]
    end
  end

  describe "get_article!/1" do
    setup :create_article

    test "returns the article with given id", %{article: article} do
      article =
        article
        |> Repo.preload(:comments)
        |> (&%{&1 | comments_count: Enum.count(&1.comments)}).()

      assert CMS.get_article!(article.id) == article
    end
  end

  describe "create_article/1" do
    test "with valid data creates a article" do
      assert {:ok, %Article{}} = CMS.create_article(@valid_attrs)
    end

    test "with published: false keeps publication date empty" do
      attrs = Map.put(@valid_attrs, :published, false)

      assert {:ok, %Article{published_at: nil}} = CMS.create_article(attrs)
    end

    test "with published: true sets the publication date" do
      attrs = Map.put(@valid_attrs, :published, true)

      assert {:ok, %Article{published_at: %DateTime{}}} = CMS.create_article(attrs)
    end

    test "with published: true sets the slug" do
      attrs = Map.put(@valid_attrs, :published, true)

      assert {:ok, %Article{slug: "blog-article"}} = CMS.create_article(attrs)
    end

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_article(@invalid_attrs)
    end
  end

  describe "update_article/2" do
    setup [:create_article, :create_draft]

    test "with valid data updates the article", %{article: article} do
      assert {:ok, %Article{}} = CMS.update_article(article, @update_attrs)
    end

    test "with published: true publish the draft", %{draft: draft} do
      attrs = Map.put(@update_attrs, :published, true)

      assert {:ok, %Article{published_at: %DateTime{}}} = CMS.update_article(draft, attrs)
    end

    test "with published: true does not change publication date", %{article: article} do
      published_at = article.published_at

      attrs = Map.put(@update_attrs, :published, true)

      assert {:ok, %Article{published_at: ^published_at}} = CMS.update_article(article, attrs)
    end

    test "with published: false unpublish the article", %{article: article} do
      attrs = Map.put(@update_attrs, :published, false)

      assert {:ok, %Article{published_at: nil}} = CMS.update_article(article, attrs)
    end

    test "with invalid data returns error changeset", %{article: article} do
      article_id = article.id

      assert {:error, %Ecto.Changeset{}} = CMS.update_article(article, @invalid_attrs)
      assert %Article{id: ^article_id} = CMS.get_article!(article.id)
    end
  end

  describe "delete_article/1" do
    setup :create_article

    test "deletes the article", %{article: article} do
      assert {:ok, %Article{}} = CMS.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_article!(article.id) end
    end
  end

  describe "change_article/1" do
    setup :create_article

    test "returns a article changeset", %{article: article} do
      assert %Ecto.Changeset{} = CMS.change_article(article)
    end
  end

  defp create_draft(_) do
    %{draft: insert(:article, published_at: nil)}
  end

  defp create_article(_) do
    %{article: insert(:article, published_at: Timex.now())}
  end
end
