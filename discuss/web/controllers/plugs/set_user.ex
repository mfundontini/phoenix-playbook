defmodule Discuss.Plugs.SetUser do
    import Plug.Conn
    import Phoenix.Controller 

    alias Discuss.Router.Helpers

    def init(params) do
        IO.inspect params
    end

    def call(conn, params) do
        user_id = get_session(conn, :user_id)

        cond do
            user = user_id && Discuss.Repo.get(Discuss.User, user_id) ->
            # Add user to assigns -> context manager for phoenix
                assign(conn, :user, user)
            true ->
            # Nullify user by setting them to nil
                assign(conn, :user, nil)
        end
    end
end