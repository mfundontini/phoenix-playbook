defmodule Discuss.TopicController do
    use Discuss.Web, :controller
    alias Discuss.Topic

    plug Discuss.Plugs.RequireAuth when action in [:new, :edit, :update, :create, :delete]
    plug :check_post_owner when action in [:edit, :update, :delete]

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

    def show(conn, %{"id" => id }) do
        case Repo.get(Topic, id) do
            :nil ->
                render conn, "404.html", id: id
            topic_struct ->
                render conn, "show.html", topic: topic_struct
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
        changeset = conn.assigns.user
        |> build_assoc(:topics)
        |> Topic.changeset(topic)

        
        case Repo.insert(changeset) do
            {:ok, post} ->
                %Topic{title: title} = post
                conn
                |> put_flash(:info, "Topic `#{title}` created.")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} -> render conn, "new.html", changeset: changeset
        end
    end

    def delete(conn, %{"id" => id}) do
        Repo.get!(Topic, id)
        |> Repo.delete!

        conn 
        |> put_flash(:info, "Topic #{id} deleted.")
        |> redirect(to: topic_path(conn, :index))
    end

    def check_post_owner(conn, _params) do
        %{params: %{"id" => id}} = conn
        user_id = conn.assigns.user.id

        if Repo.get(Topic, id).user_id == user_id do
            conn
        else
            conn
            |> put_flash(:error, "You cannot edit this.")
            |> redirect(to: topic_path(conn, :index))
            |> halt
        end
    end
end