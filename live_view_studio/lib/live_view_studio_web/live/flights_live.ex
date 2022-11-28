defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Flights
  alias LiveViewStudio.Airports

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        flight: "",
        airport: "",
        flights: [],
        matches: [],
        loading: false
      )

    {:ok, socket, temporary_assigns: [flights: [], matches: []]}
  end

  def render(assigns) do
    ~H"""
    <h1>Find a Flight</h1>
    <div id="search">
      <form id="flight-search" phx-submit="flight-search">
        <input
          type="text"
          name="flight_info"
          value={@flight}
          placeholder="flight info"
          autofocus
          autocomplete="off"
          readonly={@loading}
        />
        <button type="submit">
          <img src="images/search.svg" />
        </button>
      </form>

      <form id="airport-search" phx-submit="airport-search" phx-change="suggest-airport">
        <input
          type="text"
          name="airport"
          value={@airport}
          placeholder="airport info"
          autofocus
          autocomplete="off"
          readonly={@loading}
          list="matches"
        />
        <button type="submit">
          <img src="images/search.svg" />
        </button>
      </form>

      <datalist id="matches">
        <%= for match <- @matches do %>
          <option value={match}><%= match %></option>
        <% end %>
      </datalist>

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
                  <img src="images/location.svg" />
                  <%= flight.origin %> to <%= flight.destination %>
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

  def handle_event("suggest-airport", %{"airport" => airport}, socket) do
    socket = assign(socket, matches: Airports.suggest(airport))
    {:noreply, socket}
  end

  def handle_event("flight-search", %{"flight_info" => flight_info}, socket) do
    send(self(), {:search, flight_info})

    socket =
      socket
      |> assign(flight: flight_info, loading: true, flights: [])

    {:noreply, socket}
  end

  def handle_event("airport-search", %{"airport" => airport_info}, socket) do
    send(self(), {:airport_search, airport_info})

    socket =
      socket
      |> assign(airport: airport_info, loading: true, airports: [])

    {:noreply, socket}
  end

  def handle_info({:airport_search, airport_info}, socket) do
    case Flights.search_by_airport(airport_info) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "no fligths info for #{airport_info}")
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
