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

    resources "/posts", PostController, except: [:show]
  end

  scope "/", KosynierzyWeb.Blog, as: :blog do
    pipe_through :browser

    resources "/", PostController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", KosynierzyWeb do
  #   pipe_through :api
  # end
end
