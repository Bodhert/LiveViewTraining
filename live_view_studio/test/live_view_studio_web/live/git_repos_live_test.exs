defmodule LiveViewStudioWeb.FilterLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "filters boats by type and price", %{conn: conn} do
    repo_1 =
      create_repo(
        name: "rails",
        url: "https://github.com/rails/rails",
        owner_login: "rails",
        owner_url: "https://github.com/rails",
        fork: false,
        stars: 45600,
        language: "ruby",
        license: "mit"
      )

    {:ok, view, _html} = live(conn, "/git-repos")
    assert has_element?(view, repo_card(repo_1))
    # assert has_element?(view, boat_card(fishing_2))
    # assert has_element?(view, boat_card(sporting_2))

    # view
    # |> form("#change-filter", %{type: "fishing", prices: ["$"]})
    # |> render_change()

    # assert has_element?(view, boat_card(fishing_1))
    # refute has_element?(view, boat_card(fishing_2))
    # refute has_element?(view, boat_card(sporting_2))
  end

  defp create_repo(attrs) do
    {:ok, repo} =
      attrs
      |> Enum.into(%{})
      |> LiveViewStudio.GitRepos.create_git_repo()

    repo
  end

  defp repo_card(repo), do: "#repo-#{repo.id}"
end
