defmodule LiveViewStudioWeb.ServersLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup do
    server = create_server("any")
    {:ok, %{server: server}}
  end

  test "clicking a server link show its details", %{conn: conn} do
    second = create_server("Second")
    first = create_server("First")

    {:ok, view, _html} = live(conn, "/servers")

    assert has_element?(view, "nav", first.name)
    assert has_element?(view, "nav", second.name)

    assert has_element?(view, "#selected-server", first.name)

    view
    |> element("nav a", second.name)
    |> render_click()

    assert has_element?(view, "#selected-server", second.name)
    assert_patch(view, "/servers?name=#{second.name}")
  end

  test "select the server identified in the URL", %{conn: conn} do
    second = create_server("Second")
    _first = create_server("First")

    {:ok, view, _html} = live(conn, "/servers?name=#{second.name}")

    assert has_element?(view, "#selected-server", second.name)
  end

  test "adds valid server to the list", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/servers/new")

    valid_attrs = %{name: "Server 1", framework: "rails", size: 33, git_repo: "yiju"}

    view
    |> form("#create-server", %{server: valid_attrs})
    |> render_submit()

    assert_redirect(view, "/servers")
  end

  test "displays live validations", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/servers/new")

    invalid_valid_attrs = %{name: ""}

    view
    |> form("#create-server", %{server: invalid_valid_attrs})
    |> render_change()

    assert has_element?(view, "#create-server", "can't be blank")
  end

  test "clicking status button toggles status", %{conn: conn, server: server} do
    {:ok, view, _html} = live(conn, "/servers")

    status_button = "#toggle-#{server.name}"

    view
    |> element(status_button, "up")
    |> render_click()

    assert has_element?(view, status_button, "down")
  end

  test "receives real time updates", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/servers")

    external_server = create_server("dos")

    assert has_element?(view, "#servers", external_server.name)
  end

  defp create_server(name) do
    {:ok, server} =
      LiveViewStudio.Servers.create_server(%{
        name: name,
        # these are irrelevant for tests:
        status: "up",
        deploy_count: 1,
        size: 1.0,
        framework: "framework",
        git_repo: "repo",
        last_commit_id: "id",
        last_commit_message: "message"
      })

    server
  end
end
