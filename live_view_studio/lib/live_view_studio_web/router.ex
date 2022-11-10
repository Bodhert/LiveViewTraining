defmodule LiveViewStudioWeb.Router do
  use LiveViewStudioWeb, :router

  import LiveViewStudioWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {LiveViewStudioWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", LiveViewStudioWeb do
    pipe_through(:browser)

    live("/", PageLive, :index)
    live("/light", LightLive)
    live("/sales-dashboard", SalesDashboardLive)
    live("/search", SearchLive)
    live("/flights", FlightsLive)
    live("/autocomplete", AutocompleteLive)
    live("/filter", FilterLive)
    live("/git-repos", GitReposLive)
    live("/servers", ServersLive)
    live("/servers/new", ServersLive, :new)
    live("/paginate", PaginateLive)
    live("/vehicles", VehiclesLive)
    live("/sort", SortLive)
    live("/volunteers", VolunteersLive)
    live("/infinite-scroll", InfiniteScrollLive)
    live("/datepicker", DatePickerLive)
    live("/sandbox", SandboxLive)
    live("/chart", ChartLive)
    live("/map", MapLive)
    live("/key-events", KeyEventsLive)
    live("/desks", DesksLive)
    live("/underwater", UnderwaterLive)
    live("/underwater/show", UnderwaterLive, :show_modal)
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveViewStudioWeb do
  #   pipe_through :api
  # end

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
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: LiveViewStudioWeb.Telemetry)
    end
  end

  ## Authentication routes

  scope "/", LiveViewStudioWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live("/users/register", RegisterLive, :new, as: :user_registration)
    post("/users/register", UserRegistrationController, :create)
    get("/users/log_in", UserSessionController, :new)
    post("/users/log_in", UserSessionController, :create)
    get("/users/reset_password", UserResetPasswordController, :new)
    post("/users/reset_password", UserResetPasswordController, :create)
    get("/users/reset_password/:token", UserResetPasswordController, :edit)
    put("/users/reset_password/:token", UserResetPasswordController, :update)
  end

  scope "/", LiveViewStudioWeb do
    pipe_through([:browser, :require_authenticated_user])

    live("/topsecret", TopSecretLive)
    live("/license", LicenseLive)
    get("/users/settings", UserSettingsController, :edit)
    put("/users/settings", UserSettingsController, :update)
    get("/users/settings/confirm_email/:token", UserSettingsController, :confirm_email)
  end

  scope "/", LiveViewStudioWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)
    get("/users/confirm", UserConfirmationController, :new)
    post("/users/confirm", UserConfirmationController, :create)
    get("/users/confirm/:token", UserConfirmationController, :confirm)
  end
end
