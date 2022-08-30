defmodule LiveViewStudioWeb.FlightsLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "search by fligth number", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/flights")

    view
    |> form("#flight-search", %{flight_info: "450"})
    |> render_submit()

    assert has_element?(view, "li", "450")
  end

  test "search by airport code", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/flights")

    view
    |> form("#airport-search", %{airport: "DEN"})
    |> render_submit()

    assert has_element?(view, "li", "450")
    assert has_element?(view, "li", "740")
  end
end
