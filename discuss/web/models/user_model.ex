defmodule Discuss.User do
    use Discuss.Web, :model

    @derive {Poison.Encoder, only: [:nickname]}

    schema "users" do
        field :name, :string
        field :nickname, :string
        field :email, :string
        field :token, :string
        field :provider, :string
        has_many :topics, Discuss.Topic
        has_many :comments, Discuss.Comment

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:name, :nickname, :email, :token, :provider])
        |> validate_required([:name, :nickname, :email, :token, :provider])
    end
end