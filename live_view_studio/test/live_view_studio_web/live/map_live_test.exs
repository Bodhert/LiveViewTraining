defmodule LiveViewStudio.MapLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "reporting an incident creates a new item", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/map")

    view
    |> element("button", "Report Incident")
    |> render_click()

    assert render(view) |> number_of_incidents == 1

    view
    |> element("button", "Report Incident")
    |> render_click()

    assert render(view) |> number_of_incidents == 2
  end

  defp number_of_incidents(html) do
    html |> :binary.matches("phx-value-id") |> length()
  end
end
