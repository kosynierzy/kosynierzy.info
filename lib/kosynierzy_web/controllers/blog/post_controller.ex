defmodule KosynierzyWeb.Blog.PostController do
  use KosynierzyWeb, :controller

  alias Kosynierzy.CMS

  def index(conn, params) do
    posts = CMS.list_published_posts(params)
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"year" => year, "month" => month, "day" => day, "slug" => slug}) do
    post = CMS.get_post!(year, month, day, slug)
    render(conn, "show.html", post: post)
  end
end
