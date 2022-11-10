defmodule LiveViewStudioWeb.ModalComponent do
  use LiveViewStudioWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="phx-modal"
          phx-window-keydown="toggle-modal"
          phx-key="escape"
          phx-capture-click="toggle-modal">
          <div class="phx-modal-content">
            <a href="#" phx-click="toggle-modal" class="phx-modal-close">
              &times;
            </a>
            <%= live_component @socket, @component %>
          </div>
        </div>
    """
  end
end
