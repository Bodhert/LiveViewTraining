defmodule LiveViewStudio.SandboxLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "testing Sanbox whole flow", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/sandbox")

    view
    |> form("#calculator", %{length: 2, width: 2, depth: 2})
    |> render_change()

    render(view) =~ "You need 58.4 pounds"

    view
    |> form("#calculator", %{length: 1})
    |> render_change()

    render(view) =~ "You need 29.2 pounds"

    view
    |> form("#calculator")
    |> render_submit()

    render(view) =~ "29.2 pounds of sand for $43.80 plus $0.00 delivery"

    view
    |> form("#zip-form", %{zip: 123})
    |> render_change()

    render(view) =~ "29.2 pounds of sand for $43.80 plus $6.00 delivery"
  end
end
