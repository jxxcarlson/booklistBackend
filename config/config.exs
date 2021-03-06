# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :book_list,
  ecto_repos: [BookList.Repo]

# Configures the endpoint
config :book_list, BookListWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/cC0nbkGMPCSi40FwVhcfTC/E9WChA3BmM4/hjK9kXUFFMCknywq992Ef8c4uFFG",
  render_errors: [view: BookListWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BookList.PubSub,
           adapter: Phoenix.PubSub.PG2]


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :book_list, BookList.Mailer,
       adapter: Bamboo.MailgunAdapter,
       api_key: System.get_env("MAILGUN_API_KEY"),
       domain: "www.booklib.io"


config :book_list, BookList.BookSpace.Scheduler,
       timezone: "America/New_York",
       jobs: [
         # Every minute
         # {"* * * * *",      {Heartbeat, :send, []}},
         # Every 15 minutes
         # {"*/15 * * * *",   fn -> System.cmd("rm", ["/tmp/tmp_"]) end},
         # Runs on 18, 20, 22, 0, 2, 4, 6:
         # {"0 18-6/2 * * *", fn -> :mnesia.backup('/var/backup/mnesia') end},
         # Runs every midnight:
         {"@midnight", {BookList.BookSpace, :update_average_reading_rates, []}}
       ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
