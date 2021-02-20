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

    
end