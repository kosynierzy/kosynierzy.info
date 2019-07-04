defmodule KosynierzyWeb.Router do
  use KosynierzyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin", KosynierzyWeb.Admin, as: :admin do
    pipe_through :browser

    resources "/articles", ArticleController, except: [:show]
  end

  scope "/", KosynierzyWeb.Blog, as: :blog do
    pipe_through :browser

    resources "/articles", ArticleController, only: [:show] do
      resources "/comments", CommentController, only: [:create]
    end

    get "/", ArticleController, :index
    get "/:year", ArticleController, :index
    get "/:year/:month", ArticleController, :index
    get "/:year/:month/:day", ArticleController, :index
    get "/:year/:month/:day/:slug", ArticleController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", KosynierzyWeb do
  #   pipe_through :api
  # end
end
