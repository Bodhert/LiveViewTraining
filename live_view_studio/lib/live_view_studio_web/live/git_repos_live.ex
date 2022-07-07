defmodule LiveViewStudioWeb.GitReposLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.GitRepos

  def mount(_params, _session, socket) do
    socket = assign_defaults(socket)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Trending Git Repos</h1>
    <div id="repos">
    <form phx-change="filter">
        <div class="filters">
          <select name="language">
            <%= options_for_select(type_languaje_options(), @language)  %>
          </select>
          <select name="license">
            <%= options_for_select(license_options(), @license) %>
          </select>
          <a href="#" phx-click="clean-filters">Clear All</a>
        </div>
    </form>
    <div class="repos">
    <ul>
      <%= for repo <- @repos do %>
        <li>
          <div class="first-line">
            <div class="group">
              <img src="images/terminal.svg">
              <a href={repo.owner_url}>
                <%= repo.owner_login %>
              </a>
              /
              <a href={repo.url}>
                <%= repo.name %>
              </a>
            </div>
            <button>
              <img src="images/star.svg">
              Star
            </button>
          </div>
          <div class="second-line">
            <div class="group">
              <span class={"language #{repo.language}"}>
                <%= repo.language %>
              </span>
              <span class="license">
                <%= repo.license %>
              </span>
              <%= if repo.fork do %>
                <img src="images/fork.svg">
              <% end %>
            </div>
            <div class="stars">
              <%= repo.stars %> stars
            </div>
          </div>
        </li>
      <% end %>
    </ul>
    </div>
    </div>
    """
  end

  def handle_event("filter", %{"language" => language, "license" => license}, socket) do
    params = [language: language, license: license]
    repos = GitRepos.list_git_repos(params)
    socket = assign(socket, params ++ [repos: repos])
    {:noreply, socket}
  end

  def handle_event("clean-filters", _, socket) do
    socket = assign_defaults(socket)
    {:noreply, socket}
  end

  defp assign_defaults(socket) do
    assign(socket, repos: GitRepos.list_git_repos(), language: "", license: "", loading: false)
  end

  defp type_languaje_options do
    [
      "All Languages": "",
      "Elixir": "elixir",
      Ruby: "ruby",
      Javascript: "javascript"
    ]
  end

  defp license_options do
    [
      "All Licenses": "",
      MIT: "MIT",
      Apache: "Apache",
      BSDL: "bsdl"
    ]
  end
end