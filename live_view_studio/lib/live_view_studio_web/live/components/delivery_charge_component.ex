defmodule LiveViewStudioWeb.DeliveryChargeComponent do
  use LiveViewStudioWeb, :live_component
  alias LiveViewStudio.SandboxCalculator
  import Number.Currency

  def mount(socket) do
    socket = assign(socket, zip: nil, charge: 0)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <form phx-change="calculate" phx-target={@myself} id={@id}>
      <div class="field" >
        <label for="zip">Zip Code:</label>
        <input type="text" name="zip" value={@zip} />
        <span class="unit"><%= number_to_currency(@charge) %></span>
      </div>
    </form>
    """
  end

  def handle_event("calculate", %{"zip" => zip}, socket) do
    charge = SandboxCalculator.calculate_delivery_charge(zip)

    socket =
      assign(socket,
        zip: zip,
        charge: charge
      )

    send(self(), {:delivery_charge, charge})

    {:noreply, socket}
  end
end
