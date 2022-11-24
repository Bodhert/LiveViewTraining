defmodule LiveViewStudioWeb.LightLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "initial render", %{conn: conn} do
    {:ok, view, html} = live(conn, "/light")

    assert html =~ "porch light"
    assert render(view) =~ "porch light"
  end

  test "light controls", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/light")

    assert render(view) =~ "10%"

    assert view
           |> element("button", "Up")
           |> render_click() =~ "20%"

    assert view
           |> element("button", "Down")
           |> render_click() =~ "10%"

    assert view
           |> element("button", "On")
           |> render_click() =~ "100%"

    assert view
           |> element("button", "Off")
           |> render_click() =~ "0%"

    assert view
           |> element("#light")
           |> render_keyup(%{"key" => "ArrowUp"}) =~ "10%"

    assert view
           |> element("#light")
           |> render_keyup(%{"key" => "ArrowDown"}) =~ "0%"

    refute render(view) =~ "100%"
  end

  test "max brightness is 100%", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/light")

    assert view
           |> element("button", "On")
           |> render_click() =~ "100%"

    assert view
           |> element("button", "Up")
           |> render_click() =~ "100%"
  end

  test "min  brightness is 0%", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/light")

    assert view
           |> element("button", "Off")
           |> render_click() =~ "0%"

    assert view
           |> element("button", "Down")
           |> render_click() =~ "0%"
  end

  test "random ligth displays random value", %{conn: conn} do
    {:ok, view, html} = live(conn, "/light")

    refute view
           |> element("button", "Light Me Random!")
           |> render_click() =~ html
  end

  test "changes the temperature", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/light")

    assert view
           |> form("#temp", %{temperature: 3000})
           |> render_change() =~ "F1C40D"

    assert view
           |> form("#temp", %{temperature: 4000})
           |> render_change() =~ "FEFF66"

    assert view
           |> form("#temp", %{temperature: 5000})
           |> render_change() =~ "99CCFF"
  end
end
