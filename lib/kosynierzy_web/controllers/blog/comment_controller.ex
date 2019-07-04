defmodule KosynierzyWeb.Blog.CommentController do
  use KosynierzyWeb, :controller

  alias Kosynierzy.CMS
  alias KosynierzyWeb.Blog

  def create(conn, %{"article_id" => article_id, "comment" => comment_params}) do
    with article <- CMS.get_article!(article_id),
         ip <- conn.remote_ip,
         %{"author" => author, "author_email" => author_email, "url" => url, "content" => content} <-
           comment_params,
         [user_agent] <- Plug.Conn.get_req_header(conn, "user-agent") do
      case CMS.create_comment(article, %{user_agent: user_agent, ip: ip}, %{
             author: author,
             author_email: author_email,
             url: url,
             content: content
           }) do
        {:ok, comment} ->
          conn
          |> put_flash(:info, "Dodano")
          |> redirect(to: Routes.blog_article_path(conn, :show, comment.article_id))

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_view(Blog.ArticleView)
          |> render("show.html", article: article, changeset: changeset)
      end
    end
  end
end
