defmodule Discuss.Router do
  use Discuss.Web, :router

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

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/mock", MockController, :mock

    # Below routes can be replaced with resources "/topics" TopicController
    # Provided one follows the CRUD rules of :new, :index, :edit, :create, :delete
    
    get "/topics/new", TopicController, :new
    get "/topics", TopicController, :index
    get "/topics/:id/edit", TopicController, :edit
    put "/topics/:id", TopicController, :update
    post "/topics/create", TopicController, :create
    delete "/topics/:id/delete", TopicController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
