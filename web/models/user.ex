defmodule Support.User do
  use Support.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :encrypted_password, :string

    # Ecto thing called virtual fields, Does not save to the database
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps
  end

  @required_fields ~w(name email password password_confirmation)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  # Dataset that wraps you model. Does not need to be called changeset.
  # Called manually, not a magic method.  This is the default.
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email) #Turns nasty db errors into user friendly error message.
    |> validate_confirmation(:password, message: "must match password")
    |> encrypt_password()
  end

  #private function
  defp encrypt_password(changeset) do
    if password = get_change(changeset, :password) do
      put_change changeset, :encrypted_password, hash_password(password)
    else
      changeset
    end
  end

  defp hash_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

end
