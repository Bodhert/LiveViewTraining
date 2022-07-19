defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Servers
  alias LiveViewStudio.Servers.Server
  alias LiveViewStudio.Helpers

  def mount(_params, _session, socket) do
    servers = Servers.list_servers()
    changeset = Servers.change_server(%Server{})

    socket = assign(socket, servers: servers, changeset: changeset, selected_server: hd(servers))
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

  def handle_event("save", %{"server" => params}, socket) do
    params |> IO.inspect(label: "#{__MODULE__}: >>>>>> params <<<<<<\n")

    case Servers.create_server(params) do
      {:ok, server} ->
        socket =
          update(
            socket,
            :servers,
            fn servers -> [server | servers] end
          )

        changeset = Servers.change_server(%Server{})

        socket = assign(socket, changeset: changeset)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end

  defp link_body(server) do
    assigns = %{name: server.name, status: server.status}

    ~H"""
      <span class={"status #{@status}"}></span>
      <img src="/images/server.svg">
      <%= @name %>
    """
  end

  def handle_event("validate", %{"server" => params}, socket) do
    changeset =
      %Server{}
      |> Servers.change_server(params)
      |> Map.put(:action, :insert)

    socket = assign(socket, changeset: changeset)

    {:noreply, socket}
  end

  defp generate_input_field(form, field, placeholder) do
    assigns = %{}

    ~H"""
      <%= label form, placeholder %>
      <%= text_input(form, field,
        autocomplete: "off",
        phx_debounce: "blur"
      ) %>
      <%= error_tag form, field %>
    """
  end
end
