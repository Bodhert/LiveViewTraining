defmodule LiveViewStudioWeb.FilterLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Boats

  def mount(_params, _session, socket) do
    socket = assign_defaults(socket)
    {:ok, socket, temporary_assigns: [boats: []]}
  end

  def render(assigns) do
    ~H"""
    <h1>Daily Boat Rentals</h1>
    <div id="filter">
      <form id="change-filter" phx-change="filter">
        <div class="filters">
          <select name="type">
            <%= options_for_select(type_options(), @type) %>
          </select>
          <div class="prices">
            <input type="hidden" name="prices[]" value="" />
            <%= for price <- ["$", "$$", "$$$"] do %>
              <%= price_checkbox(%{price: price, checked: price in @prices}) %>
            <% end %>
          </div>
          <a href="#" phx-click="clean-filters">Clear All</a>
        </div>
      </form>
      <div class="boats">
        <%= for boat <- @boats do %>
          <div id={"boat-#{boat.id}"} class="card">
            <img src={boat.image} />
            <div class="content">
              <div class="model">
                <%= boat.model %>
              </div>
              <div class="details">
                <span class="price">
                  <%= boat.price %>
                </span>
                <span class="type">
                  <%= boat.type %>
                </span>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    params = [type: type, prices: prices]
    boats = Boats.list_boats(params)
    socket = assign(socket, params ++ [boats: boats])
    {:noreply, socket}
  end

  def handle_event("clean-filters", _, socket) do
    socket = assign_defaults(socket)
    {:noreply, socket}
  end

  defp price_checkbox(assigns) do
    ~H"""
    <input type="checkbox" id={@price} name="prices[]" value={@price} checked={@checked} />
    <label for={@price}><%= @price %></label>
    """
  end

  defp assign_defaults(socket) do
    assign(socket, boats: Boats.list_boats(), type: "", prices: [])
  end

  defp type_options do
    [
      "All types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end
end
