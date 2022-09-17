defmodule LiveViewStudioWeb.InfiniteScrollLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders more orders when the user scrolls to bottom", %{conn: conn} do
    create_order()
    {:ok, view, _html} = live(conn, "/infinite-scroll")

    assert render(view) |> number_of_order() == 10

    view
    |> element("#footer")
    |> render_hook("load-more", %{})

    assert render(view) |> number_of_order() == 11
  end

  defp number_of_order(html) do
    html |> :binary.matches("Test Pizza") |> length()
  end

  defp create_order do
    for i <- 1..11 do
      {:ok, _order} =
        LiveViewStudio.PizzaOrders.create_pizza_order(%{
          username: "Test user #{i}",
          pizza: "Test Pizza #{i}"
        })
    end
  end
end
