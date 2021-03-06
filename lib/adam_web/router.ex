defmodule AdamWeb.Router do
  @moduledoc false

  use AdamWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Casex.CamelCaseDecoderPlug
  end

  scope "/api", AdamWeb do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/transmissions", TransmissionController, except: [:new, :edit, :delete] do
        resources "/messages", MessageController, only: [:index, :show]
      end

      resources "/messages", MessageController, only: [:index, :show]
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: AdamWeb.Telemetry
    end
  end
end
