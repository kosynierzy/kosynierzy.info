defmodule KosynierzyWeb.Admin.ArticleController do
  use KosynierzyWeb, :controller

  alias Kosynierzy.CMS
  alias Kosynierzy.CMS.Article

  def index(conn, _params) do
    articles = CMS.list_articles()
    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params) do
    changeset = CMS.change_article(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    case CMS.create_article(article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: Routes.admin_article_path(conn, :edit, article))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    article = CMS.get_article!(id)
    changeset = CMS.change_article(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = CMS.get_article!(id)

    case CMS.update_article(article, article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: Routes.admin_article_path(conn, :edit, article))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", article: article, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = CMS.get_article!(id)
    {:ok, _article} = CMS.delete_article(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: Routes.admin_article_path(conn, :index))
  end
end
