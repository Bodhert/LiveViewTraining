defmodule LiveViewStudioWeb.UnderwaterLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :show_modal, false)}
  end

  def render(assigns) do
    ~H"""
    <h1>Earth Is Super Watery</h1>
    <div id="underwater">
      <button phx-click="toggle-modal">
      🤿 Look Underwater 👀
      </button>

      <%= if @show_modal do %>
        <%= live_component @socket,
             LiveViewStudioWeb.ModalComponent,
             id: :modal,
             component: LiveViewStudioWeb.CreaturesComponent  %>
      <% end  %>
    </div>
    """
  end

  def handle_event("toggle-modal", _, socket) do
    {:noreply, update(socket, :show_modal, &(!&1))}
  end
end
