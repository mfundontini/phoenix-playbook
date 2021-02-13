defmodule Discuss.TopicController do
    use Discuss.Web, :controller
    alias Discuss.Topic

    def new(conn, params) do
        changeset = topic.changeset(%Topic{}, %{})
        render conn, "new.html", changeset: changeset
    end
end