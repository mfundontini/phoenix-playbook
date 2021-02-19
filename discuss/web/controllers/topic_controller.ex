defmodule Discuss.TopicController do
    use Discuss.Web, :controller
    alias Discuss.Topic

    def new(conn, params) do
        changeset = Topic.changeset(%Topic{}, %{})
        render conn, "new.html", changeset: changeset
    end

    def create(conn, %{"topic" => topic }) do
        changeset = Topic.changeset(%Topic{}, topic)

        case Repo.insert(changeset) do
        {:ok, post} -> render conn, "create.html"
        {:error, reason} -> render conn, "create.html"
        end
    end
end