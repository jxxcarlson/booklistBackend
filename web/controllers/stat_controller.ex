defmodule BookList.StatController do
  use BookList.Web, :controller

  alias BookList.Stat

  def index(conn, _params) do
    stats = Repo.all(Stat)
    render(conn, "index.json", stats: stats)
  end

  def create(conn, %{"stat" => stat_params}) do
    changeset = Stat.changeset(%Stat{}, stat_params)

    case Repo.insert(changeset) do
      {:ok, stat} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", stat_path(conn, :show, stat))
        |> render("show.json", stat: stat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BookList.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    stat = Repo.get!(Stat, id)
    render(conn, "show.json", stat: stat)
  end

  def update(conn, %{"id" => id, "stat" => stat_params}) do
    stat = Repo.get!(Stat, id)
    changeset = Stat.changeset(stat, stat_params)

    case Repo.update(changeset) do
      {:ok, stat} ->
        render(conn, "show.json", stat: stat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BookList.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    stat = Repo.get!(Stat, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(stat)

    send_resp(conn, :no_content, "")
  end
end
