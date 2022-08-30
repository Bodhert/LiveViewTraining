defmodule LiveViewStudioWeb.FlightsLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup do
    create_flight(number: "450", origin: "DEN", destination: "ORD")
    create_flight(number: "740", origin: "DEN", destination: "ORD")
    {:ok, %{}}
  end

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

  def create_flight(attrs) do
    {:ok, flight} =
      attrs
      |> Enum.into(%{
        departure_time: ~N[2022-08-30 21:19:28],
        arrival_time: ~N[2022-09-01 21:19:28]
      })
      |> LiveViewStudio.Flights.create_flight()

    flight
  end
end
