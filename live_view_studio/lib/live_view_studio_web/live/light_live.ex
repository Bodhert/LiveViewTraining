defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 10, temperature: 3000)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <h1>Front porch light</h1>
      <div id="light">
      <div class="meter">
      <span style={"background-color:#{temp_color(@temperature)}; width: #{@brightness}%"}>
        <%= @brightness %>%
      </span>
      </div>
      <button phx-click="off">
        <img src="images/light-off.svg">
      </button>

      <button phx-click="down">
        <img src="images/down.svg">
      </button>

      <button phx-click="up">
        <img src="images/up.svg">
      </button>


      <button phx-click="on">
      <img src="images/light-on.svg">
      </button>

      <button phx-click="random">
        Light Me Up!
      </button>

      <form phx-change="update">
      <input type="range" min="0" max="100"
              name="brightness" value={@brightness} />
      </form>

      <form phx-change="change-temp">
        <input type="radio" id="3000" name="temperature" value="3000" checked={@temperature == 3000}/>
        <label for="3000">3000</label>
        <input type="radio" id="4000" name="temperature" value="4000" checked={@temperature == 4000} />
        <label for="4000">4000</label>
        <input type="radio" id="5000" name="temperature" value="5000" checked={@temperature == 5000}/>
        <label for="5000">5000</label>
      </form>
      </div>

    """
  end

  def handle_event("on", _, socket) do
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, :brightness, 0)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))
    {:noreply, socket}
  end

  def handle_event("random", _, socket) do
    socket = assign(socket, :brightness, Enum.random(0..100))
    {:noreply, socket}
  end

  def handle_event("update", %{"brightness" => brightness}, socket) do
    socket = assign(socket, brightness: brightness)
    {:noreply, socket}
  end

  def handle_event("change-temp", %{"temperature" => temperature}, socket) do
    temperature = String.to_integer(temperature)
    socket = assign(socket, temperature: temperature)
    {:noreply, socket}
  end

  defp temp_color(3000), do: "#F1C40D"
  defp temp_color(4000), do: "#FEFF66"
  defp temp_color(5000), do: "#99CCFF"
end
