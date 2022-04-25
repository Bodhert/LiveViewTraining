defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <h1>Front porch light</h1>
      <div id="light">
      <div class="meter">
      <span style={"width: #{@brightness}%"}>
        <%= @brightness %> %
      </span>
      </div>
      <button>
        <img src="images/light-off.svg">
      </button>

      <button>
        <img src="images/light-on.svg">
      </button>
      </div>
    """
  end
end