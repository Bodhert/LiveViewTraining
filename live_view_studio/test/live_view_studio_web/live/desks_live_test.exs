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

  test "uploading a blank file cant be blank"

  test "fails with big file size"

  test "fails when uploading more than 3 files"
end
