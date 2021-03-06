import Config
# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :budget_tracking_tool, BudgetTrackingTool.Repo,
  username: "postgres",
  password: "postgres",
  database: "budget_tracking_tool_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# Configure the database for GitHub Actions
if System.get_env("GITHUB_ACTIONS") do
  config :budget_tracking_tool, BudgetTrackingTool.Repo,
    hostname: "localhost",
    username: "postgres",
    password: "postgres"
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :budget_tracking_tool, BudgetTrackingToolWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  server: false

# In test we don't send emails.
config :budget_tracking_tool, BudgetTrackingTool.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
