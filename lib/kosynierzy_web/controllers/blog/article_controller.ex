defmodule KosynierzyWeb.Blog.ArticleController do
  use KosynierzyWeb, :controller

  alias Kosynierzy.CMS

  def index(conn, params) do
    articles = CMS.list_published_articles(params)
    render(conn, "index.html", articles: articles)
  end

  def show(conn, %{"id" => id}) do
    with article <- CMS.get_article!(id),
         published_at <- article.published_at,
         year <- published_at.year,
         month <- published_at.month |> zeropad(),
         day <- published_at.day |> zeropad(),
         path <- Routes.blog_article_path(conn, :show, year, month, day, article.slug) do
      conn |> redirect(to: path)
    end
  end

  def show(conn, %{"year" => year, "month" => month, "day" => day, "slug" => slug}) do
    article = CMS.get_article!(year, month, day, slug)

    changeset = %CMS.Comment{} |> CMS.change_comment()

    render(conn, "show.html", article: article, changeset: changeset)
  end

  defp zeropad(num) do
    num |> Integer.to_string() |> String.pad_leading(2, "0")
  end
end
