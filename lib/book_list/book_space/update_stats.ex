defmodule BookList.BookSpace.UpdateStats do
  @moduledoc false

  use GenServer

  alias BookList.BookSpace.Stat

  @timeout 3600000 # one hour

  def start_link() do
     GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    # wait 2 secs for a call. Since nothing sends a message to this process,
    # it gets the timeout message
    IO.puts "Updating stats (1)"
    Stat.create
    {:ok, state, @timeout}
  end

  # Once timeout passes, this callback gets called,
  # thus we can execute our code
  def handle_info(:timeout, state) do
    IO.puts "Updating stats"

    Stat.delete_for_today
    Stat.create
    # after executing the code, we schedule another execution,
    # so it works like a loop
    {:noreply, state, @timeout}
  end




end
