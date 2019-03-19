
defmodule BookListWeb.MailView do

  use BookListWeb, :view
  alias BookListWeb.MailView



  @moduledoc false


  def render("reply.json", %{message: message}) do
    %{reply: message}
  end


  def render("error.json", %{error: error}) do
    %{error: error}
  end

end
