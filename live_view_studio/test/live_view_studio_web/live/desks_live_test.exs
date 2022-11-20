defmodule LiveViewStudioWeb.DesksLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "testing a file photo upload", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/desks")

    image =
      file_input(view, "#create-desk", :photo, [
        %{
          name: "test",
          content: File.read!("test/support/desks/1.jpeg"),
          type: "image/jpeg"
        }
      ])

    render_upload(image, "test")

    view
    |> form("#create-desk", %{"desk[name]" => "test"})
    |> render_submit()

    assert render(view) =~ "test"
    assert has_element?(view, "#photos", "test")
  end

  test "file name cant be blank", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/desks")

    view
    |> form("#create-desk", %{"desk[name]" => ""})
    |> render_submit()

    assert render(view) =~ "can&#39;t be blank"
  end

  test "fails with big file size", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/desks")

    image =
      file_input(view, "#create-desk", :photo, [
        %{
          name: "big",
          content: File.read!("test/support/desks/big.jpg"),
          type: "image/jpeg"
        }
      ])

    render_upload(image, "big")

    assert render(view) =~ "File too large"
  end

  test "fails when trying to upload more than 3 files", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/desks")

    images =
      for _n <- 1..4 do
        file_input(view, "#create-desk", :photo, [
          %{
            name: "test",
            content: File.read!("test/support/desks/1.jpeg"),
            type: "image/jpeg"
          }
        ])
      end

    Enum.each(images, &render_upload(&1, "test"))

    assert render(view) =~ "You&#39;ve selected too many files"
  end
end
