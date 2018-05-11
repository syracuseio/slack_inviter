defmodule SlackInviterWeb.Router do
  use SlackInviterWeb, :router

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

  scope "/", SlackInviterWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    scope "/invite" do
      pipe_through :browser

      get "/", InviteController, :index
      post "/", InviteController, :create
    end
  end

  # # Other scopes may use custom stacks.
  # scope "/api", SlackInviterWeb do
  #   pipe_through :api
  #
  #   # / desrcibes what this is
  #   # /api/:slackname/info
  #   # /api/:slackname/register
  #   get "/:slackname", SlackController, :show
  #   post "/:slackname/register", SlackController, :create
  # end
end
