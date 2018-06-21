defmodule BookList.UserSpace.Token do

  @moduledoc """
  This module carries the functions used to generate tokens,
  determine whether they are valid, and inspec the token payload.
  """

    import Joken


    @doc """
    Return a signed token with payload %{user_id: USER_ID, username: USERNAME.
    NOTE: the payload is NOT encrypted and so can be read by anyone
    """
    def get(user_id, username, seconds_from_now \\ -1) do
      t = if (seconds_from_now < 0) do
        System.get_env("BOOKLIB_EXPIRATION") |> String.to_integer
      else
        seconds_from_now
      end
      secret = System.get_env("BOOKLIB_SECRET")
      cond do
        user_id == nil -> {:error, 400}
        username == nil -> {:error, 400}
        true ->
          %{"user_id" => user_id, "username" => username,
             "exp" => expiration_time(t)}
          |> token
          |> with_validation("user_id", &(&1 == user_id))
          |> with_signer(hs256(secret))
          |> sign
          |> get_compact
          |> (fn token -> {:ok, token} end).()
      end
    end

    def expiration_time(seconds_from_now) do
      now = DateTime.utc_now() |> DateTime.to_unix()
      now + seconds_from_now
    end

    def validate(tok, user_id) do
      secret = System.get_env("BOOKLIB_SECRET")
      tok
      |> token
      |> with_validation("user_id", &(&1 == user_id))
      |> with_signer(hs256(secret))
      |> verify
    end

    def validate(tok) do
      secret = System.get_env("BOOKLIB_SECRET")
      tok
      |> token
      |> with_signer(hs256(secret))
      |> verify
    end

    @doc """
    Return true iff the token signature is valid and the token's signed user_id
    is the same as user_id.
    """
    def authenticated(token, user_id) do
      vt = validate(token, user_id)
      signature_valid = vt.error == nil
      now = DateTime.utc_now() |> DateTime.to_unix()
      expired = vt.claims["exp"] <= now
      signature_valid && not expired
    end

    @doc """
    Return true iff the token signature is valid.
    """
    def authenticated(token) do
      vt = validate(token)
      signature_valid = vt.error == nil
      now = DateTime.utc_now() |> DateTime.to_unix()
      expired = vt.claims["exp"] <= now
      signature_valid && not expired
    end

    defp decode2string(token) do
      token
      |> String.split(".")
      |> Enum.at(1)
      |> Base.decode64(padding: false)
    end

    @doc """
    payload("aaa.bbb.ccc) == {{:ok, %{"user_id" => 2, "username" => "yada"}}
    in the case that the payload segment is valid. Here "valid" means a
    correctly base64-encoded representation of a struct.  NOTE that the payload
    is not encrypted and can be read by anyone.

    payload("aaa.bbb.ccc) == {:error, "Could not decode payload"} in the
    invalid case.
    """
    def payload(token) do
      with {:ok, str} <- decode2string(token),
           {:ok, json} <- Poison.Parser.parse str
      do
        {:ok, json}
      else
        _ -> {:error, "Could not decode payload"}
      end
    end

    def get_header(conn, name) do
       result = Plug.Conn.get_req_header(conn, name)
       case result do
           [] -> {:error, "No #{name} header"}
           _ -> {:ok, result}
       end
    end

    # def token_from_header1(conn) do
    #   headers = Plug.Conn.get_req_header(conn, "authorization")
    #   IO.puts "HEADERS:"
    #   IO.inspect headers
    #   authorization_header = hd headers
    #   case String.split(authorization_header, " ") do
    #     ["Bearer", token] ->  {:ok, token}
    #     _ -> {:error, "Could not decode token from header"}
    #   end
    # end

    def token_from_header(conn) do
      with {:ok, header} <- get_header(conn, "authorization"),
           ["Bearer", token] <- String.split(hd(header), " ")
      do
        {:ok, token}
      else
        {:error, error} -> "error: #{error}"
      end
    end


    # js, {"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0OTYxNTc1NzIsInVzZXJfaWQiOjE2OSwidXNlcm5hbWUiOiJqb2UifQ.hISpUvnv1ZGnSGqggelYjpjml2v_cXH-GuXaaLgPOs8"}
    # jc, {"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0OTYxNzgxNDksInVzZXJfaWQiOjIsInVzZXJuYW1lIjoianh4Y2FybHNvbiJ9.KUfL8dk2_Xz2ltaPqXyfoLb7ZfZ1n4_JCpJFDZgu2Zc"}

    def authenticated_from_header(conn) do
      IO.puts "AUTH CONN"
      with {:ok, token} <- token_from_header(conn)
      do
         {:ok,  authenticated(token)}
      else
        _ -> {:error, "authentication error (2)"}
      end
    end

    def username_from_header(conn) do
      with {:ok, token} <- token_from_header(conn),
           true <- authenticated(token),
           {:ok, json} <- payload(token)
      do
         {:ok, json["username"]}
      else
        _ -> {:error, "Could not get verified username"}
      end
    end

    def user_id_from_header(conn) do
      with {:ok, token} <- token_from_header(conn),
           true <- authenticated(token),
           {:ok, json} <- payload(token)
      do
         {:ok, json["user_id"]}
      else
        _ -> {:error, "Could not get verified user ID"}
      end
    end

    def user_id_from_token(token) do
      with true <- authenticated(token),
           {:ok, json} <- payload(token)
      do
         {:ok, json["user_id"]}
      else
        _ -> {:error, "Could not get verified user ID"}
      end
    end

    def email_from_token(token) do
      with true <- authenticated(token),
           {:ok, json} <- payload(token)
      do
         {:ok, json["email"]}
      else
        _ -> {:error, "Could not get verified email"}
      end
    end

    def payload_from_token(token) do
      with true <- authenticated(token),
           {:ok, json} <- payload(token)
      do
         {:ok, json}
      else
        _ -> {:error, "Could not get verified email"}
      end
    end

end
