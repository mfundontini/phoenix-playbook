defmodule Discuss.TopicController do
    use Discuss.Web, :controller
    alias Discuss.Topic

    def new(conn, params) do
        changeset = Topic.changeset(%Topic{}, %{})
        render conn, "new.html", changeset: changeset
    end

    def create(conn, params) do
        IO.inspect(params)
        IO.inspect(conn)
        render conn, "create.html"
    end
end