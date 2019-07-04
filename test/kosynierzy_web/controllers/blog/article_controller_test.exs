defmodule KosynierzyWeb.Blog.ArticleControllerTest do
  use KosynierzyWeb.ConnCase

  alias Kosynierzy.CMS

  @published_attrs %{
    title: "Blog article",
    content: "Blog content",
    published_at: "2019-01-01 12:00"
  }
  @draft_attrs %{title: "Draft", content: "Draft"}

  def fixture(:published_article) do
    {:ok, article} = CMS.create_article(@published_attrs)
    article
  end

  def fixture(:draft) do
    {:ok, article} = CMS.create_article(@draft_attrs)
    article
  end

  describe "index" do
    setup [:create_articles]

    test "lists all published articles", %{conn: conn} do
      conn = get(conn, Routes.blog_article_path(conn, :index))
      assert html_response(conn, 200) =~ "Blog article"
    end

    test "does not list drafts", %{conn: conn} do
      conn = get(conn, Routes.blog_article_path(conn, :index))
      refute html_response(conn, 200) =~ "Draft"
    end
  end

  describe "index by year" do
    setup [:create_articles]

    test "lists all published articles in a year", %{conn: conn} do
      conn = get(conn, Routes.blog_article_path(conn, :index, "2019"))
      assert html_response(conn, 200) =~ "Blog article"
    end

    test "does not list articles from different year", %{conn: conn} do
      conn = get(conn, Routes.blog_article_path(conn, :index, "2018"))
      refute html_response(conn, 200) =~ "Nic nie znaleziono"
    end
  end

  defp create_articles(_) do
    fixture(:published_article)
    fixture(:draft)

    :ok
  end
end
