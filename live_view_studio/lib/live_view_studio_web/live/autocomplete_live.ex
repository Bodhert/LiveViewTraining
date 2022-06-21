defmodule LiveViewStudioWeb.AutocompleteLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Stores
  alias LiveViewStudio.Cities

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        zip: "",
        city: "",
        stores: [],
        matches: [],
        loading: false
      )

    {:ok, socket, temporary_assigns: [stores: [], matches: []]}
  end

  def render(assigns) do
    ~H"""
    <h1>Find a Store</h1>
    <div id="search">

    <form phx-submit="zip-search">
    <input type="text" name="zip" value={@zip} placeholder="Zip Code"
      autofocus autocomplete="off" readonly={@loading}/>

      <button type="submit">
        <img src="images/search.svg" >
      </button>
    </form>

    <form phx-submit="city-search" phx-change="suggest-city">
    <input type="text" name="city" value={@city} placeholder="City name"
       autocomplete="off" readonly={@loading} list="matches" phx-debounce="1000"/>
      <button type="submit">
        <img src="images/search.svg" >
      </button>
    </form>

    <datalist id="matches">
      <%= for match <- @matches do %>
        <option value={match}><%= match %></option>
      <% end %>
    </datalist>


    <%= if @loading do %>
      <div class="loader">
        Loading...
      </div>
    <% end %>

    <div class="stores">
    <ul>
      <%= for store <- @stores do %>
        <li>
          <div class="first-line">
            <div class="name">
              <%= store.name %>
            </div>
            <div class="status">
              <%= if store.open do %>
                <span class="open">Open</span>
              <% else %>
                <span class="closed">Closed</span>
              <% end %>
            </div>
          </div>
          <div class="second-line">
            <div class="street">
              <img src="images/location.svg">
              <%= store.street %>
            </div>
            <div class="phone_number">
              <img src="images/phone.svg">
              <%= store.phone_number %>
            </div>
          </div>
        </li>
      <% end %>
    </ul>
    </div>
    </div>
    """
  end

  def handle_event("suggest-city", %{"city" => prefix}, socket) do
    socket = assign(socket, matches: Cities.suggest(prefix))
    {:noreply, socket}
  end

  def handle_event("city-search", %{"city" => city_code}, socket) do
    city_code |> IO.inspect(label: "#{__MODULE__}: >>>>>> city <<<<<<\n")
    send(self(), {:run_city_search, city_code})

    socket =
      assign(socket,
        city: city_code,
        loading: true,
        stores: []
      )

    {:noreply, socket}
  end

  def handle_event("zip-search", %{"zip" => zip_code}, socket) do
    send(self(), {:run_zip_search, zip_code})

    socket =
      assign(socket,
        zip: zip_code,
        loading: true,
        stores: []
      )

    {:noreply, socket}
  end

  def handle_info({:run_city_search, city_code}, socket) do
    case Stores.search_by_city(city_code) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No stores matching \"#{city_code}\"")
          |> assign(stores: [], loading: false)

        {:noreply, socket}

      stores ->
        socket =
          socket
          |> clear_flash()
          |> assign(stores: stores, loading: false)

        {:noreply, socket}
    end
  end

  def handle_info({:run_zip_search, zip_code}, socket) do
    case Stores.search_by_zip(zip_code) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No stores matching \"#{zip_code}\"")
          |> assign(stores: [], loading: false)

        {:noreply, socket}

      stores ->
        socket =
          socket
          |> clear_flash()
          |> assign(stores: stores, loading: false)

        {:noreply, socket}
    end
  end
end
