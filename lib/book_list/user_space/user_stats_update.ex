defmodule BookList.UserSpace.UserStatsUpdate do
  @moduledoc false



    use GenServer

    alias BookList.UserSpace.User
    alias BookList.Repo
    alias BookList.UserSpace

    # @timeout 3600000 # one hour

    # @timeout 120_000 # two minutes

    @timeout 3_600_000 # one hour

    def start_link() do
      GenServer.start_link(__MODULE__, [])
    end

    def init(state) do
      # wait 2 secs for a call. Since nothing sends a message to this process,
      # it gets the timeout message
      today = Date.utc_today

      Repo.all(User)
        |> Enum.map (fn(user) -> UserSpace.update_reading_stats(user, today) end)

      {:ok, state, @timeout}
    end

    # Once timeout passes, this callback gets called,
    # thus we can execute our code
    def handle_info(:timeout, state) do
      today = Date.utc_today

      Repo.all(User)
      |> Enum.map (fn(user) -> UserSpace.update_reading_stats(user, today) end)

      # after executing the code, we schedule another execution,
      # so it works like a loop
      {:noreply, state, @timeout}
    end







end
