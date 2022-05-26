defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Flights

  def mount(_params, _session, socket) do
    socket = assign(socket, loading: false, flight: "", flights: [])
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Find a Flight</h1>
    <div id="search">
    <form phx-submit="flight-search">
    <input type="text" name="flight-info" value={@flight} placeholder="flight info"
      autofocus autocomplete="off" readonly={@loading} />
      <button type="submit">
        <img src="images/search.svg" >
      </button>
    </form>

      <%= if @loading do %>
        <div class="loader">Loading...</div>
      <% end %>

      <div class="flights">
        <ul>
          <%= for flight <- @flights do %>
            <li>
              <div class="first-line">
                <div class="number">
                  Flight #<%= flight.number %>
                </div>
                <div class="origin-destination">
                  <img src="images/location.svg">
                  <%= flight.origin %> to
                  <%= flight.destination %>
                </div>
              </div>
              <div class="second-line">
                <div class="departs">
                  Departs: <%= format_time(flight.departure_time) %>
                </div>
                <div class="arrives">
                  Arrives: <%= format_time(flight.arrival_time) %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  defp format_time(time) do
    Timex.format!(time, "%b %d at %H:%M", :strftime)
  end

  def handle_event("flight-search", %{"flight-info" => flight_info}, socket) do
    send(self(), {:search, flight_info})

    socket =
      socket
      |> assign(flight: flight_info, loading: true, flights: [])

    {:noreply, socket}
  end

  def handle_info({:search, flight_info}, socket) do
    case Flights.search_by_number(flight_info) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "no fligths info for #{flight_info}")
          |> assign(flights: [], loading: false)

        {:noreply, socket}

      result ->
        socket =
          socket
          |> clear_flash()
          |> assign(flights: result, loading: false)

        {:noreply, socket}
    end
  end
end
