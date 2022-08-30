defmodule LiveViewStudioWeb.GitReposLiveTest do
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

    repo_2 =
      create_repo(
        name: "elixir",
        url: "https://github.com/elixir/elixir",
        owner_login: "elixir",
        owner_url: "https://github.com/elixir",
        fork: false,
        stars: 45600,
        language: "elixir",
        license: "apache"
      )

    {:ok, view, _html} = live(conn, "/git-repos")
    assert has_element?(view, repo_card(repo_1))
    assert has_element?(view, repo_card(repo_2))

    view
    |> form("#change-filter", %{language: "elixir", license: "apache"})
    |> render_change()

    assert has_element?(view, repo_card(repo_2))
    refute has_element?(view, repo_card(repo_1))
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
