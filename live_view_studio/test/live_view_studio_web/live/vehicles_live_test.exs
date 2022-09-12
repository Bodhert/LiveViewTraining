defmodule LiveViewStudioWeb.VehiclesLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "test navigation", %{conn: conn} do
    vehicle1 = create_vehicle("A", "A", "A")
    vehicle2 = create_vehicle("B", "B", "B")
    {:ok, view, _html} = live(conn, "/vehicles?page=1&per_page=1")

    assert has_element?(view, "tr", vehicle1.make)

    view
    |> element("a", "Next")
    |> render_click()

    assert has_element?(view, "tr", vehicle2.make)
    assert_patched(view, "/vehicles?page=2&per_page=1&sort_by=color&sort_order=asc")

    view
    |> element("a", "Previous")
    |> render_click()

    assert_patched(view, "/vehicles?page=1&per_page=1&sort_by=color&sort_order=asc")

    view
    |> element("a", "2")
    |> render_click()

    assert has_element?(view, "tr", vehicle2.make)
    assert_patched(view, "/vehicles?page=2&per_page=1&sort_by=color&sort_order=asc")
  end

  test "vehicles using the url", %{conn: conn} do
    vehicle1 = create_vehicle("A", "A", "A")
    vehicle2 = create_vehicle("B", "B", "B")

    {:ok, view, _html} = live(conn, "/vehicles?page=1&per_page=1&sort_by=color&sort_order=asc")

    assert has_element?(view, vehicle_row(vehicle1))
    refute has_element?(view, vehicle_row(vehicle2))

    {:ok, view, _html} = live(conn, "/vehicles?page=2&per_page=1&sort_by=color&sort_order=asc")
    assert has_element?(view, vehicle_row(vehicle2))
    refute has_element?(view, vehicle_row(vehicle1))

    {:ok, view, _html} = live(conn, "/vehicles?page=1&per_page=2&sort_by=color&sort_order=asc")
    assert has_element?(view, vehicle_row(vehicle1))
    assert has_element?(view, vehicle_row(vehicle2))
  end

  test "changing per-page form patches the url", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/vehicles?page=2")

    view
    |> form("#select-per-page", %{"per-page": 10})
    |> render_change()

    assert_patched(view, "/vehicles?page=2&per_page=10")
  end

  defp create_vehicle(make, model, color) do
    {:ok, vehicle} =
      LiveViewStudio.Vehicles.create_vehicle(%{
        make: make,
        model: model,
        color: color
      })

    vehicle
  end

  defp vehicle_row(vehicle), do: "#vehicle-#{vehicle.id}"
end
