defmodule Support.PageController do
  use Support.Web, :controller

  def index(conn, _params) do
    #IO.inspect conn
    render conn, "index.html"
  end

  def hello(conn, %{"name" => name}) do
    render conn, "hello.html", name: name
  end
end
