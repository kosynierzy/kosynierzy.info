defmodule KosynierzyWeb.Blog.PostControllerTest do
  use KosynierzyWeb.ConnCase

  alias Kosynierzy.CMS

  @published_attrs %{
    title: "Blog post",
    content: "Blog content",
    published_at: "2019-01-01 12:00"
  }
  @draft_attrs %{title: "Draft", content: "Draft"}

  def fixture(:published_post) do
    {:ok, post} = CMS.create_post(@published_attrs)
    post
  end

  def fixture(:draft) do
    {:ok, post} = CMS.create_post(@draft_attrs)
    post
  end

  describe "index" do
    setup [:create_posts]

    test "lists all published posts", %{conn: conn} do
      conn = get(conn, Routes.blog_post_path(conn, :index))
      assert html_response(conn, 200) =~ "Blog post"
    end

    test "does not list drafts", %{conn: conn} do
      conn = get(conn, Routes.blog_post_path(conn, :index))
      refute html_response(conn, 200) =~ "Draft"
    end
  end

  describe "index by year" do
    setup [:create_posts]

    test "lists all published posts in a year", %{conn: conn} do
      conn = get(conn, Routes.blog_post_path(conn, :index, "2019"))
      assert html_response(conn, 200) =~ "Blog post"
    end

    test "does not list posts from different year", %{conn: conn} do
      conn = get(conn, Routes.blog_post_path(conn, :index, "2018"))
      refute html_response(conn, 200) =~ "Nic nie znaleziono"
    end
  end

  defp create_posts(_) do
    fixture(:published_post)
    fixture(:draft)

    :ok
  end
end
