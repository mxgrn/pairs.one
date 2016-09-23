defmodule PairsOne.PageController do
  use PairsOne.Web, :controller

  def index(conn, _params) do
    render conn, "index.#{locale}.html"
  end
end
