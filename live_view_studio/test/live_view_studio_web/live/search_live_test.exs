defmodule LiveViewStudioWeb.SearchLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup do
    create_store(name: "Downtown Denver", zip: "80204")
    create_store(name: "Midtown Denver", zip: "80204")
    create_store(name: "Denver Stapleton", zip: "80204")
    create_store(name: "Denver West", zip: "80204")
    {:ok, %{}}
  end

  test "initial render", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/search")

    assert render(view) =~ "Find a Store"
  end

  test "search shows matching stores", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/search")

    view
    |> form("#zip-search", %{zip: 80204})
    |> render_submit()

    assert has_element?(view, "li", "Downtown Denver")
    assert has_element?(view, "li", "Midtown Denver")
    assert has_element?(view, "li", "Denver Stapleton")
    assert has_element?(view, "li", "Denver West")
  end

  test "no existing zip code show no matching store", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/search")

    view
    |> form("#zip-search", %{zip: 00000})
    |> render_submit()

    assert has_element?(view, "[role=alert]", "No stores matching")
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
