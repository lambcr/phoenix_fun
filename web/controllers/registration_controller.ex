defmodule Support.RegistrationController do
  use Support.Web, :controller

  #allows us to use User without Support
  alias Support.User

  # removing blanks and making them nil
  # you could call this explicitly in create chain
  plug :scrub_params, "user" when action in [:create]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "registered successfully!")
        |> put_session(:current_user, user.id)
        |> redirect(to: "/")
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
