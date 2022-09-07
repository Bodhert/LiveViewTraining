defmodule LiveViewStudioWeb.PaginateLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "test navigation", %{conn: conn} do
    donation1 = create_donation("papayita")
    donation2 = create_donation("manguito")
    {:ok, view, _html} = live(conn, "/paginate?page=1&per_page=1")

    assert has_element?(view, "tr", donation1.item)

    view
    |> element("a", "Next")
    |> render_click()

    assert has_element?(view, "tr", donation2.item)
    assert_patched(view, "/paginate?page=2&per_page=1")

    view
    |> element("a", "Previous")
    |> render_click()

    assert_patched(view, "/paginate?page=1&per_page=1")

    view
    |> element("a", "2")
    |> render_click()

    assert has_element?(view, "tr", donation2.item)
    assert_patched(view, "/paginate?page=2&per_page=1")
  end

  test "paginates using the url", %{conn: conn} do
    donation1 = create_donation("papayita")
    donation2 = create_donation("manguito")

    {:ok, view, _html} = live(conn, "/paginate?page=1&per_page=1")

    assert has_element?(view, donation_row(donation1))
    refute has_element?(view, donation_row(donation2))

    {:ok, view, _html} = live(conn, "/paginate?page=2&per_page=1")
    assert has_element?(view, donation_row(donation2))
    refute has_element?(view, donation_row(donation1))

    {:ok, view, _html} = live(conn, "/paginate?page=1&per_page=2")
    assert has_element?(view, donation_row(donation1))
    assert has_element?(view, donation_row(donation2))
  end

  test "changing per-page form patches the url", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate?page=2")

    view
    |> form("#select-per-page", %{"per-page": 10})
    |> render_change()

    assert_patched(view, "/paginate?page=2&per_page=10")
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

  defp donation_row(donation), do: "#donation-#{donation.id}"
end
