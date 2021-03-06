defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth
    alias Discuss.User

    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
        user = %{
            token: auth.credentials.token, name: auth.info.name, 
            nickname: auth.info.nickname, email: auth.info.email, provider: "github"
        }

       changeset = User.changeset(%User{}, user)

       sign_in(conn, changeset)
    end

    defp insert_or_update_user(changeset) do
        case Repo.get_by(User, email: changeset.changes.email) do
            nil ->
                Repo.insert(changeset)
            user -> 
                {:ok, user}
        end
    end

    def sign_out(conn, _params) do
        conn
        |> configure_session(drop: true)
        |> put_flash(:info, "User logged out")
        |> redirect(to: topic_path(conn, :index))
    end

    defp sign_in(conn, changeset) do
        case insert_or_update_user(changeset) do
            {:ok, user} ->
                conn
                |> put_flash(:info, "#{user.name} has been logged in.")
                |> put_session(:user_id, user.id)
                |> redirect(to: topic_path(conn, :index))

            {:error, _reason} ->
                conn
                |> put_flash(:error, "Error signing in.")
                |> redirect(to: topic_path(conn, :index))
        end
    end
end