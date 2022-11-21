defmodule LiveViewStudioWeb.SandboxLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudioWeb.QuoteComponent
  alias LiveViewStudioWeb.SandboxCalculatorComponent
  alias LiveViewStudioWeb.DeliveryChargeComponent

  def mount(_params, _session, socket) do
    {:ok, assign(socket, weight: nil, price: nil, charge: nil)}
  end

  def render(assigns) do
    ~H"""
      <h1>Build a Sand box</h1>
      <div id="sandbox">
        <%= live_component @socket, SandboxCalculatorComponent,
                            id: "calculator" %>
        <%= live_component @socket, DeliveryChargeComponent, id: "zip-form" %>
        <%= if @weight do %>
          <QuoteComponent.quote
              material="sand"
              weight={@weight}
              price={@price}
              hrs_until_expires="4"
              charge={@charge}/>
        <% end %>
      </div>
    """
  end

  def handle_info({:totals, weight, price}, socket) do
    socket = assign(socket, weight: weight, price: price)
    {:noreply, socket}
  end

  def handle_info({:delivery_charge, charge}, socket) do
    socket = assign(socket, charge: charge)
    {:noreply, socket}
  end
end
