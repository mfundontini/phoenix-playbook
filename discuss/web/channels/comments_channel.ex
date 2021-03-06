defmodule Discuss.CommentsChannel do
    use Discuss.Web, :channel

    def join("comments:" <> topic_id, _auth, socket) do
        pk = String.to_integer(topic_id)
        
        topic = Discuss.Topic
        |> Repo.get(pk)
        |> Repo.preload(comments: [:user])

        IO.inspect topic

        case topic do
            :nil ->
                {:error, %{error: "Could not join topic #{pk}"}, socket}
            topic_struct ->
                {:ok, %{comments: topic_struct.comments}, assign(socket, :topic, topic_struct)}
        end
    end

    def handle_in(name, %{"content" => content}, socket) do
        topic = socket.assigns.topic
        user_id = socket.assigns.user_id
        changeset = topic
        |> build_assoc(:comments, user_id: user_id)
        |> Discuss.Comment.changeset(%{content: content})

        case Repo.insert(changeset) do
            {:ok, comment} ->
                broadcast!(socket, "comments:#{topic.id}:new", %{comment: comment})
                {:reply, :ok, socket}
            {:error, _reason} ->
                {:reply, {:error, %{errors: changeset}}, socket}
        end
    end
end