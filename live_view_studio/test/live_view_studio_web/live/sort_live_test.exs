defmodule LiveViewStudioWeb.SortLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "test navigation", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/sort")

    view
    |> element("a", "Item")
    |> render_click()

    assert_patched(view, sort_path("item", "desc"))

    view
    |> element("a", "Quantity")
    |> render_click()

    assert_patched(view, sort_path("quantity", "asc"))

    view
    |> element("a", "Days Until Expires")
    |> render_click()

    assert_patched(view, sort_path("days_until_expires", "desc"))
  end

  test "paginates using the url", %{conn: conn} do
    donation1 = create_donation("A")
    donation2 = create_donation("B")
    donation3 = create_donation("C")

    {:ok, view, _html} = live(conn, sort_path("item", "asc"))

    assert render(view) =~ donations_in_order(donation1, donation2, donation3)
  end

  test "displays the selected per_page items", %{conn: conn} do
    for i <- 1..10 do
      create_donation("testaroo-#{i}")
    end

    {:ok, view, html} = live(conn, "/sort")

    assert has_element?(view, "#paginate-options", "5")
    assert number_of_items(html) == 5

    view
    |> form("#paginate", %{"per-page" => "10"})
    |> render_change()

    assert has_element?(view, "#paginate-options", "10")
    assert number_of_items(render(view)) == 10
  end

  defp donations_in_order(first, second, third) do
    ~r/#{first.item}.*#{second.item}.*#{third.item}/s
  end

  defp sort_path(sort_by, sort_order) do
    "/sort?" <> "sort_by=#{sort_by}&sort_order=#{sort_order}&page=1&per_page=5"
  end

  defp number_of_items(html) do
    html |> :binary.matches("testaroo") |> length()
  end

  defp create_donation(item) do
    {:ok, donation} =
      LiveViewStudio.Donations.create_donation(%{
        item: item,
        # these are irrelevant for tests:
        emoji: "🥝",
        quantity: 1,
        days_until_expires: 1
      })

    donation
  end
end
