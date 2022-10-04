defmodule LiveViewStudioWeb.LicenseLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import LiveViewStudio.AccountsFixtures

  test "Updating number of seats changes seats and amount", %{conn: conn} do
    user = user_fixture()

    {:ok, view, _html} =
      conn
      |> log_in_user(user)
      |> live("/license")

    assert has_element?(view, "#seats", "3")
    assert has_element?(view, "#amount", "$60.00")

    view
    |> form("#update-seats", %{seats: 4})
    |> render_change()

    assert has_element?(view, "#seats", "4")
    assert has_element?(view, "#amount", "$80.00")
  end
end
