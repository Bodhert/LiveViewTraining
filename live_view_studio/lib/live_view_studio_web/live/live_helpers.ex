defmodule LiveViewStudioWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias LiveViewStudio.Accounts

  def assign_current_user(socket, session) do
    assign_new(
      socket,
      :current_user,
      fn ->
        Accounts.get_user_by_session_token(session["user_token"])
      end
    )
  end
end
