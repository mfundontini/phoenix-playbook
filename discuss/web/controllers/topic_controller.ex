defmodule Discuss.TopicController do
    use Discuss.Web, :controller
    alias Discuss.Topic

    def new(conn, params) do
        changeset = topic.changeset(%Topic{}, %{})
        render conn, "new.html", changeset: changeset
    end

    def create(conn, params) do
        IO.inspect(params)
        IO.insepect(conn)
        render conn, "create.html"
    end
end