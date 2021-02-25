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

    def handle_in(name, %{"content" => content}, socket) do
        IO.inspect message
        topic = socket.assigns.topic
        changeset = topic
        |> build_assoc(:comments)
        |> Discuss.Comment.changeset(%{content: content})

        case Repo.inspect(changeset) do
            {:ok, comment} ->
                {:reply, :ok, socket}
            {:error, _reason} ->
                {:reply, {:error, %{errors: changeset}}, socket}
        end
    end
end