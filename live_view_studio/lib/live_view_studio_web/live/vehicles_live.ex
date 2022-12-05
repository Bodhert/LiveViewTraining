defmodule LiveViewStudioWeb.VehiclesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Vehicles
  alias LiveViewStudio.Helpers

  @permitted_sort_bys ~w(color make model id)
  @permitted_sort_orders ~w(asc desc)

  def mount(_params, _session, socket) do
    {:ok, assign(socket, total_vehicles: Vehicles.count_vehicles()),
     temporary_assigns: [vehicles: []]}
  end

  def handle_params(params, _url, socket) do
    page = Helpers.param_to_integer(params["page"], 1)
    per_page = Helpers.param_to_integer(params["per_page"], 5)

    sort_by =
      params
      |> Helpers.param_of_first_permitted("sort_by", @permitted_sort_bys)
      |> String.to_atom()

    sort_order =
      params
      |> Helpers.param_of_first_permitted("sort_order", @permitted_sort_orders)
      |> String.to_atom()

    paginate_options = %{page: page, per_page: per_page}
    sort_options = %{sort_by: sort_by, sort_order: sort_order}
    vehicles = Vehicles.list_vehicles(paginate: paginate_options, sort: sort_options)

    socket =
      assign(socket, options: Map.merge(paginate_options, sort_options), vehicles: vehicles)

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    per_page = String.to_integer(per_page)

    socket =
      push_patch(socket,
        to: ~p"/vehicles?page=#{socket.assigns.options.page}&per_page=#{per_page}"
      )

    {:noreply, socket}
  end
end
