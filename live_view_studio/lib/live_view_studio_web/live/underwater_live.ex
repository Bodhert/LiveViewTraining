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
        <div class="phx-modal"
          phx-window-keydown="toggle-modal"
          phx-key="escape"
          phx-capture-click="toggle-modal">
          <div class="phx-modal-content">
            <a href="#" phx-click="toggle-modal" class="phx-modal-close">
              &times;
            </a>
            <div class="creatures">
              🐙 🐳 🦑 🐡 🐚 🐋 🐟 🦈 🐠 🦀 🐬
            </div>
            <button phx-click="toggle-modal">
             I'm outta air!
            </button>
          </div>
        </div>
      <% end  %>
    </div>
    """
  end

  def handle_event("toggle-modal", _, socket) do
    {:noreply, update(socket, :show_modal, &(!&1))}
  end
end
