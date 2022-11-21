defmodule LiveViewStudioWeb.KeyEventsLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "pressing -> changes to the next picture", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/key-events")

    before_key_press = render(view)

    after_key_press =
      view
      |> element("#key-events")
      |> render_keyup(%{"key" => "ArrowRight"})

    refute before_key_press =~ after_key_press
  end

  test "pressing <- changes to the previous picture", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/key-events")

    before_key_press = render(view)

    after_key_press =
      view
      |> element("#key-events")
      |> render_keyup(%{"key" => "ArrowLeft"})

    refute before_key_press =~ after_key_press
  end

  test "pressing k plays the pictures", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/key-events")

    key_press =
      view
      |> element("#key-events")
      |> render_keyup(%{"key" => "k"})

    assert key_press =~ "Playing"
  end

  test "sending the picture name renders it", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/key-events")

    assert view
           |> element("input")
           |> render_keyup(%{"key" => "Enter", "value" => "3"}) =~ "3"
  end
end
