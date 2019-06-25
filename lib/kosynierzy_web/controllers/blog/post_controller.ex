defmodule KosynierzyWeb.Blog.PostController do
  use KosynierzyWeb, :controller

  alias Kosynierzy.Blog
  alias Kosynierzy.Blog.Post

  def index(conn, _params) do
    posts = Blog.list_published_posts()
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    render(conn, "show.html", post: post)
  end
end
