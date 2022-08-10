defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Servers
  alias LiveViewStudio.Servers.Server
  alias LiveViewStudioWeb.ServerComponent
  alias LiveViewStudioWeb.ServerFormComponent

  def mount(_params, _session, socket) do
    if connected?(socket), do: Servers.subscribe()
    servers = Servers.list_servers()

    socket = assign(socket, servers: servers, selected_server: hd(servers))
    {:ok, socket}
  end

  def handle_params(%{"name" => name}, _url, socket) do
    server = Servers.get_server_by_name(name)

    socket =
      assign(socket,
        selected_server: server,
        page_title: "What's up #{server.name}?"
      )

    {:noreply, socket}
  end

  def handle_params(_params, _url, socket) do
    if socket.assigns.live_action == :new do
      changeset = Servers.change_server(%Server{})

      socket =
        assign(socket,
          selected_server: nil,
          changeset: changeset
        )

      {:noreply, socket}
    else
      socket =
        assign(socket,
          selected_server: hd(socket.assigns.servers)
        )

      {:noreply, socket}
    end

    {:noreply, socket}
  end

  def handle_info({:server_created, server}, socket) do
    socket =
      update(
        socket,
        :servers,
        fn servers -> [server | servers] end
      )

    {:noreply, socket}
  end

  def handle_info({:server_updated, server}, socket) do
    socket =
      if server.name == socket.assigns.selected_server.name do
        assign(socket, selected_server: server)
      else
        socket
      end

    servers = Servers.list_servers()
    socket = assign(socket, servers: servers)
    {:noreply, socket}
  end

  defp link_body(server) do
    assigns = %{name: server.name, status: server.status}

    ~H"""
      <span class={"status #{@status}"}></span>
      <img src="/images/server.svg">
      <%= @name %>
    """
  end
end
