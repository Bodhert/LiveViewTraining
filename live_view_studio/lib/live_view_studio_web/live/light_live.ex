defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 10, temperature: 3000)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <h1>Front porch light</h1>
      <div id="light" phx-window-keyup="update">
      <div class="meter">
      <span style={"background-color:#{temp_color(@temperature)}; width: #{@brightness}%"}>
        <%= @brightness %>%
      </span>
      </div>
      <button phx-click="off">
        <img src="images/light-off.svg">
        <span class="sr-only">Off</span>
      </button>

      <button phx-click="down">
        <img src="images/down.svg">
        <span class="sr-only">Down</span>
      </button>

      <button phx-click="up">
        <img src="images/up.svg">
        <span class="sr-only">Up</span>
      </button>


      <button phx-click="on">
        <img src="images/light-on.svg">
        <span class="sr-only">On</span>
      </button>

      <button phx-click="random">
        Light Me Random!
      </button>

      <form phx-change="update">
      <input type="range" min="0" max="100"
              name="brightness" value={@brightness} />
      </form>

      <form phx-change="change-temp">
        <%= for temp <- [3000, 4000, 5000] do %>
          <%=  temp_radio_button(temp: temp, checked: temp == @temperature)%>
        <% end %>
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

  def handle_event("update", %{"key" => "ArrowUp"}, socket) do
    {:noreply, update(socket, :brightness, &min(&1 + 10, 100))}
  end

  def handle_event("update", %{"key" => "ArrowDown"}, socket) do
    {:noreply, update(socket, :brightness, &max(&1 - 10, 0))}
  end

  def handle_event("update", _, socket), do: {:noreply, socket}

  defp temp_color(3000), do: "#F1C40D"
  defp temp_color(4000), do: "#FEFF66"
  defp temp_color(5000), do: "#99CCFF"

  defp temp_radio_button(assigns) do
    assigns = Enum.into(assigns, %{})

    ~H"""
        <input type="radio" id={@temp} name="temperature" value={@temp} checked={@checked}/>
        <label for={@temp}><%= @temp %></label>
    """
  end
end
