defmodule Discuss.MockController do
  use Discuss.Web, :controller

  def mock(conn, _params) do
    render conn, "mock.html"
  end
end
