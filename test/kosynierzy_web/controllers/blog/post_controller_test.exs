defmodule KosynierzyWeb.Blog.PostControllerTest do
  use KosynierzyWeb.ConnCase

  alias Kosynierzy.Blog

  @create_attrs %{title: "Blog post", content: "Blog content"}

  def fixture(:post) do
    {:ok, post} = Blog.create_post(@create_attrs)
    post
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.blog_post_path(conn, :index))
      assert html_response(conn, 200) =~ "Wpisy"
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end
end
