defmodule LiveViewStudioWeb.AutocompleteLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup do
    create_store(name: "Downtown Denver", zip: "80204", city: "Denver, CO")
    create_store(name: "Midtown Denver", zip: "80204", city: "Denver, CO")
    create_store(name: "Denver Stapleton", zip: "80204", city: "Denver, CO")
    create_store(name: "Denver West", zip: "80204", city: "Denver, CO")
    {:ok, %{}}
  end

  test "search shows matching stores", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/autocomplete")

    view
    |> form("#city-search", %{city: "D"})
    |> render_change()

    assert has_element?(view, "#matches option", "Denver, CO")
  end

  test "search by city", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/autocomplete")

    view
    |> form("#city-search", %{city: "Denver, CO"})
    |> render_submit()

    assert has_element?(view, "li", "Downtown Denver")
    assert has_element?(view, "li", "Midtown Denver")
    assert has_element?(view, "li", "Denver Stapleton")
    assert has_element?(view, "li", "Denver West")
  end

  test "non existing city show no matching store", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/autocomplete")

    view
    |> form("#city-search", %{city: "Ragnarok"})
    |> render_submit()

    assert render(view) =~ "No stores matching"
  end

  def create_store(attrs) do
    {:ok, store} =
      attrs
      |> Enum.into(%{
        street: "street",
        phone_number: "phone",
        city: "city",
        open: true,
        hours: "hours"
      })
      |> LiveViewStudio.Stores.create_store()

    store
  end
end
