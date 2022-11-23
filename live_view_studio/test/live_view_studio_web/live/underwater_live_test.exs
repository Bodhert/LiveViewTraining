defmodule LiveViewStudioWeb.UnderwaterLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the page", %{conn: conn} do
    {:ok, view, html} = live(conn, "/underwater")
    assert html =~ "🤿 Look Underwater 👀"
  end

  test "when button is clicked renders the modal"
end
