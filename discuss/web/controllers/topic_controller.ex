defmodule Discuss.TopicController do
    use Discuss.Web, :controller
    alias Discuss.Topic

    def new(conn, params) do
        changeset = Topic.changeset(%Topic{}, %{})
        render conn, "new.html", changeset: changeset
    end

    def create(conn, %{"topic" => topic } = params) do
        changeset = Topic.changeset(%Topic{}, params)

        case Repo.insert(changeset) do
        {:ok, post} -> IO.inspect post
        {:error, reason} -> IO.inspect reason
        end
        
        IO.inspect(topic)
        render conn, "create.html"
    end
end