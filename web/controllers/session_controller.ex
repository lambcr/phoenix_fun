defmodule Support.SessionController do
  use Support.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias Support.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)

    if user && checkpw(password, user.encrypted_password) do 
      conn
      |> put_session(:current_user, user.id)
      |> put_flash(:info, "logged in!")
      |> redirect(to: page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Email or Password incorrect")
      |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "logged out!")
    |> redirect(to: "/")
  end

  defp session_params do
    %{"session" => %{"email" => email, "password" => password}}
  end
end
