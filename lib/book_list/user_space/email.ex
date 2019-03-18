
defmodule BookList.UserSpace.Email do
  import Bamboo.Email

  alias BookList.Mailer
  alias BookList.UserSpace.Token
  alias  BookListWeb.Configuration



  def email(params) do
    if params["type"] == "html_text" do
      email_html(params)
    else
      email_plain(params)
    end
  end

  def email_html(params) do
    IO.puts "Email.email, sending to #{params["recipient"]}"
    new_email
    |> to(params["recipient"])
    |> from("support@booklib.io")
    |> subject(params["subject"])
    |> html_body(params["body"])
    |> Mailer.deliver_now
  end


  def email_plain(params) do
    IO.puts "Email.email, sending to #{params["recipient"]}"
    new_email
    |> to(params["recipient"])
    |> from("support@booklib.io")
    |> subject(params["subject"])
    |> text_body(params["body"])
    |> Mailer.deliver_now
  end

  def welcome_letter(user) do
    {:ok, token} = Token.get(user.id, user.username, 30*60*1000)
    """
    <p>
    Dear #{user.username}
    </p>

    <p>Thank you for joining booklib.io. Please
    <a href="#{Configuration.host}/api/verify/#{token}" >click on this link</a> to activate
    your account.</p>

    <br>
    Regards,
    <br>
    The booklib Team

    """
  end

  def verification_letter(user) do
    {:ok, token} = Token.get(user.id, user.username, 30*60*1000)
    """
    <p>
    Dear #{user.username}
    </p>

    <p>Please
    <a href="#{Configuration.host}/api/verify/#{token}" >click on this link</a> to activate
    your account.</p>

    <br>
    Regards,
    <br>
    The booklib Team

    """
  end

end
