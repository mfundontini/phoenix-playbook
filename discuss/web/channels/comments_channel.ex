defmodule Discuss.CommentsChannel do
    use Discuss.Web, :channel

    def join("comments:" <> topic_id, _auth, socket) do
        pk = String.to_integer(topic_id)

        case Repo.get(Discuss.Topic, pk) do
            :nil ->
                {:error, %{error: "Could not join topic #{pk}"}, socket}
            topic_struct ->
                {:ok, %{message: "Successfully joined topic #{topic_struct.id}"}, assign(socket, :topic, topic_struct)}
        end
        {:ok, %{message: "just joined"}, socket}
    end

    def handle_in(name, message, socket) do
        IO.inspect message
        {:reply, :ok, socket}
    end
end