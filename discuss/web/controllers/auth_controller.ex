defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth

    def callback(conn, params) do
        IO.inspect params
        IO.puts "++++++++++++++++++++++++"
        IO.inspect conn.assigns
    end
end