defmodule BudgetTrackingToolWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :budget_tracking_tool

  @session_options [
    store: PhoenixLiveSession,
    key: "_budget_tracking_tool_key",
    pub_sub: BudgetTrackingTool.PubSub,
    # It is completely safe to hard code and use these salt values.
    signing_salt: "XCu9aYUeZ",
    encryption_salt: "jIOxYIG2l"
  ]

  socket "/socket", BudgetTrackingToolWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :budget_tracking_tool,
    gzip: false,
    only_matching: ~w(assets css fonts images js favicon robots.txt 502.html maintenance.html
        apple-touch android-chrome browserconfig manifest mstile
        safari-pinned-tab)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :budget_tracking_tool
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug BudgetTrackingToolWeb.Router
end
