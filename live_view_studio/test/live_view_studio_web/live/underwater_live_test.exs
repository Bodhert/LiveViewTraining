defmodule LiveViewStudioWeb.UnderwaterLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the page", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/underwater")
    assert html =~ "🤿 Look Underwater 👀"
  end
end
