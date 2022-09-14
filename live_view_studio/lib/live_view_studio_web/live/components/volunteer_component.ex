defmodule LiveViewStudioWeb.VolunteerComponent do
  use Phoenix.LiveComponent

  alias LiveViewStudio.Volunteers

  def render(assigns) do
    ~H"""
    <div class={"volunteer #{if @volunteer.checked_out, do: "out"}"} id={"volunteer-#{@volunteer.id}"}>
        <div class="name">
          <%= @volunteer.name %>
        </div>
        <div class="phone">
          <img src="images/phone.svg">
          <%= @volunteer.phone %>
        </div>
        <div class="status">
            <button phx-click="toggle-status" phx-value-id={@volunteer.id}  phx-target={@myself}
                    phx_disable_with="Saving...">
              <%= if @volunteer.checked_out, do: "Check In", else: "Check Out" %>
            </button>
        </div>
      </div>
    """
  end

  def handle_event("toggle-status", %{"id" => id}, socket) do
    volunteer = Volunteers.get_volunteer!(id)

    {:ok, _volunteer} = Volunteers.toggle_status_volunteer(volunteer)

    {:noreply, socket}
  end
end
