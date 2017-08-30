defmodule GraphqlDemoWeb.PageController do
  use GraphqlDemoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
