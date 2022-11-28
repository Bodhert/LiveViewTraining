defmodule LiveViewStudioWeb.ServerComponent do
  use Phoenix.LiveComponent
  alias LiveViewStudio.Servers

  def render(assigns) do
    ~H"""
    <div class="card">
      <div class="header">
        <h2><%= @selected_server.name %></h2>
        <button
          class={@selected_server.status}
          phx-click="toggle-status"
          phx_disable_with="Saving..."
          phx-value-name={@selected_server.name}
          phx-target={@myself}
          id={"toggle-#{@selected_server.name}"}
        >
          <%= @selected_server.status %>
        </button>
      </div>
      <div class="body">
        <div class="row">
          <div class="deploys">
            <img src="/images/deploy.svg" />
            <span>
              <%= @selected_server.deploy_count %> deploys
            </span>
          </div>
          <span>
            <%= @selected_server.size %> MB
          </span>
          <span>
            <%= @selected_server.framework %>
          </span>
        </div>
        <h3>Git Repo</h3>
        <div class="repo">
          <%= @selected_server.git_repo %>
        </div>
        <h3>Last Commit</h3>
        <div class="commit">
          <%= @selected_server.last_commit_id %>
        </div>
        <blockquote>
          <%= @selected_server.last_commit_message %>
        </blockquote>
      </div>
    </div>
    """
  end

  def handle_event("toggle-status", %{"name" => name}, socket) do
    server = Servers.get_server_by_name(name)

    case Servers.toggle_server_status(server) do
      {:ok, _server} ->
        {:noreply, socket}
    end
  end
end
