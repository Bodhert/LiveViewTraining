defmodule LiveViewStudioWeb.DatePickerLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "picking a date displays it on the html", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/datepicker")

    assert view
           |> element("#date-picker-input")
           |> render_hook("dates-picked", ["November 01, 2022"]) =~ "See you on November 01, 2022"
  end
end
