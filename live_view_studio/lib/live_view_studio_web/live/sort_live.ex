defmodule LiveViewStudioWeb.SortLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations
  alias LiveViewStudio.Helpers

  @permitted_sort_bys ~w(item quantity days_until_expires)
  @permitted_sort_orders ~w(asc desc)

  def mount(_params, _session, socket) do
    {:ok, assign(socket, total_donations: Donations.count_donations()),
     temporary_assigns: [donations: []]}
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
    donations = Donations.list_donations(paginate: paginate_options, sort: sort_options)

    socket =
      assign(socket, options: Map.merge(paginate_options, sort_options), donations: donations)

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    per_page = String.to_integer(per_page)

    params = %{
      sort_by: socket.assigns.options.sort_by,
      sort_order: socket.assigns.options.sort_order,
      page: socket.assigns.options.page,
      per_page: per_page
    }

    socket =
      push_patch(socket,
        to: ~p"/sort?#{params}"
      )

    {:noreply, socket}
  end

  defp expires_class(donation) do
    if Donations.almost_expired?(donation), do: "eat-now", else: "fresh"
  end
end
