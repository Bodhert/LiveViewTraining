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

  # test "search by city", %{conn: conn} do
  #   {:ok, view, _html} = live(conn, "/autocomplete")

  #   view
  #   |> form("#city-search", %{city: "Denver, CO"})
  #   |> render_submit()

  #   assert has_element?(view, "li", "Downtown Denver")
  #   assert has_element?(view, "li", "Midtown Denver")
  #   assert has_element?(view, "li", "Denver Stapleton")
  #   assert has_element?(view, "li", "Denver West")
  # end

  # test "non existing city show no matching store", %{conn: conn} do
  #   {:ok, view, _html} = live(conn, "/autocomplete")

  #   view
  #   |> form("#city-search", %{city: "Ragnarok"})
  #   |> render_submit()

  #   assert render(view) =~ "No stores matching"
  # end
end
