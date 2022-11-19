defmodule LiveViewStudioWeb.ChartLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "when clicked get reading it changes the page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/chart")

    before_refresh =
      view
      |> render()
      |> get_text_for_selector("#reading")

    after_refresh =
      view
      |> element("button", "Get Reading")
      |> render_click()
      |> get_text_for_selector("#reading")

    refute before_refresh =~ after_refresh
  end

  test "displays a new point when the event is send", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/chart")

    before_update =
      view
      |> render()
      |> get_text_for_selector("#reading")

    send(view.pid, :update)

    after_update =
      view
      |> render()
      |> get_text_for_selector("#reading")

    refute before_update =~ after_update
  end

  defp get_text_for_selector(html, selector) do
    html
    |> Floki.parse_document!()
    |> Floki.find(selector)
    |> Floki.text()
  end
end
