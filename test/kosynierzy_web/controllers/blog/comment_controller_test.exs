defmodule KosynierzyWeb.Blog.CommentControllerTest do
  use KosynierzyWeb.ConnCase

  import Kosynierzy.Factory

  @user_agent "Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:67.0) Gecko/20100101 Firefox/67.0"

  @create_attrs %{
    author: "some author",
    author_email: "some author_email",
    content: "some content",
    url: "some url"
  }
  @invalid_attrs %{author: nil, author_email: nil, content: nil, url: nil}

  describe "create comment" do
    setup [:mock_user_agent, :create_article]

    test "redirects to article when data is valid", %{conn: conn, article: article} do
      conn =
        post(conn, Routes.blog_article_comment_path(conn, :create, article),
          comment: @create_attrs
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.blog_article_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn, article: article} do
      conn =
        post(conn, Routes.blog_article_comment_path(conn, :create, article),
          comment: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Popraw błędy"
    end
  end

  defp mock_user_agent(context) do
    %{context | conn: context.conn |> put_req_header("user-agent", @user_agent)}
  end

  defp create_article(_) do
    %{article: insert(:article)}
  end
end
