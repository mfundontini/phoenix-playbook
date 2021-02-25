defmodule Discuss.CommentsChannel do
    use Discuss.Web, :channel

    def join(name, _auth, socket) do
        {:ok, %{message: "just joined"}, socket}
    end

    def handle_in(name, message, socket) do
        IO.inspect message
        {:reply, :ok, socket}
    end
end