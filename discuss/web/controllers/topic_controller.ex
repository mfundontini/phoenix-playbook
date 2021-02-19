defmodule Discuss.TopicController do
    use Discuss.Web, :controller
    alias Discuss.Topic

    def new(conn, _params) do
        changeset = Topic.changeset(%Topic{}, %{})
        render conn, "new.html", changeset: changeset
    end

    def edit(conn, %{"id" => id }) do
        case Repo.get(Topic, id) do
            :nil ->
                render conn, "404.html", id: id
            topic_struct ->
                changeset = Topic.changeset(topic_struct)
                render conn, "edit.html", changeset: changeset, topic: topic_struct
        end
    end

    def update(conn, %{"id" => id, "topic" => topic }) do

        old = Repo.get(Topic, id)
        changeset = Topic.changeset(old, topic)

        case Repo.update(changeset) do
            {:ok, post} ->
                %Topic{title: title} = post
                conn
                |> put_flash(:info, "Topic `#{title}` updated.")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} -> render conn, "edit.html", changeset: changeset, topic: old
        end
    end

    def index(conn, _params) do
        topics = Repo.all(Topic)
        render conn, "index.html", topics: topics
    end

    def create(conn, %{"topic" => topic }) do
        changeset = Topic.changeset(%Topic{}, topic)

        case Repo.insert(changeset) do
            {:ok, post} ->
                %Topic{title: title} = post
                conn
                |> put_flash(:info, "Topic `#{title}` created.")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} -> render conn, "new.html", changeset: changeset
        end
    end

    def delete(conn, params) do
    end
end