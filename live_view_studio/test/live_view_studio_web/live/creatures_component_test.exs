defmodule LiveViewStudioWeb.CreaturesComponentTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias LiveViewStudioWeb.CreaturesComponent

  test "renders quote with 24-hour expiry by default" do
    assigns = %{
      opts: [
        title: "test",
        return_to: "/return_to"
      ]
    }

    html = render_component(&CreaturesComponent.render/1, assigns)

    assert html =~ "test"
    assert html =~ "/return_to"
  end
end
