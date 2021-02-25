defmodule Discuss.CommentsChannel do
    use Discuss.Web, :channel

    def join("comments:" <> topic_id, _auth, socket) do
        pk = String.to_integer(topic_id)
        
        topic = Discuss.Topic
        |> Repo.get(pk)
        |> Repo.preload(:comments)

        case topic do
            :nil ->
                {:error, %{error: "Could not join topic #{pk}"}, socket}
            topic_struct ->
                {:ok, %{comments: topic_id.comments}, assign(socket, :topic, topic_struct)}
        end
        {:ok, %{message: "just joined"}, socket}
    end

    def handle_in(name, %{"content" => content}, socket) do
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