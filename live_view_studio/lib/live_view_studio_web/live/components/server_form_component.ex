defmodule LiveViewStudioWeb.ServerFormComponent do
  use LiveViewStudioWeb, :live_component

  alias LiveViewStudio.Servers
  alias LiveViewStudio.Servers.Server

  def mount(socket) do
    changeset = Servers.change_server(%Server{})
    socket = assign(socket, changeset: changeset)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form
        id="create-server"
        :let={f}
        for={@changeset}
        action="#"
        phx-submit="save"
        phx-change="validate"
        phx-target={@myself}
      >
        <%= generate_input_field(f, :name, "Name") %>
        <%= generate_input_field(f, :framework, "Framework") %>
        <%= generate_input_field(f, :size, "Size (MB)") %>
        <%= generate_input_field(f, :git_repo, "Git Repo") %>
        <%= submit("Save", phx_disable_with: "Saving ....") %>
        <%= live_patch("Cancel",
          replace: true,
          to: Keyword.fetch!(assigns.opts, :return_to),
          class: "cancel"
        ) %>
      </.form>
    </div>
    """
  end

  def handle_event("save", %{"server" => params}, socket) do
    case Servers.create_server(params) do
      {:ok, _server} ->
        socket =
          push_redirect(socket,
            to: Keyword.fetch!(socket.assigns.opts, :return_to)
          )

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
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
    assigns = %{form: form, field: field, placeholder: placeholder}

    ~H"""
    <%= label(@form, @placeholder) %>
    <%= text_input(@form, @field,
      autocomplete: "off",
      phx_debounce: "blur"
    ) %>
    <%= error_tag(@form, @field) %>
    """
  end
end
