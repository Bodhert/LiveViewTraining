defmodule LiveViewStudioWeb.RegisterLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "invalid attributes should yield errors", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/users/register")

    view
    |> form("#register", %{})
    |> render_change()

    assert render(view) =~ "can&#39;t be blank"

    view
    |> form("#register", %{"user[email]" => "invalid", "user[password]" => "123"})
    |> render_change()

    assert render(view) =~ "must have the @ sign and no spaces"
    assert render(view) =~ "should be at least 12 "
  end

  test "sending correct params redirects to home with the user register", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/users/register")

    view
    |> form("#register", %{"user[email]" => "test@test", "user[password]" => "test123456789"})
    |> render_submit()

    assert render(view) =~ "test@test"
  end
end
