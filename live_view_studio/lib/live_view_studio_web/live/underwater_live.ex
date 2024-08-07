defmodule LiveViewStudioWeb.UnderwaterLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Earth Is Super Watery</h1>
    <div id="underwater">
      <%= live_patch("🤿 Look Underwater 👀",
        to: ~p"/underwater/show",
        class: "button"
      ) %>

      <%= if @live_action == :show_modal do %>
        <%= live_modal(LiveViewStudioWeb.CreaturesComponent,
          return_to: ~p"/underwater",
          title: "Sea Creatures"
        ) %>
      <% end %>
    </div>
    """
  end
end
