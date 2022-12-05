defmodule LiveViewStudioWeb.PaginateLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(_params, _session, socket) do
    {:ok, assign(socket, total_donations: Donations.count_donations()),
     temporary_assigns: [donations: []]}
  end

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")

    paginate_options = %{page: page, per_page: per_page}
    donations = Donations.list_donations(paginate: paginate_options)
    socket = assign(socket, options: paginate_options, donations: donations)

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    per_page = String.to_integer(per_page)

    socket =
      push_patch(socket,
        to: ~p"/paginate?page=#{socket.assigns.options.page}&per_page=#{per_page}"
      )

    {:noreply, socket}
  end

  def handle_event("paginate", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, goto_page(socket, socket.assigns.options.page - 1)}
  end

  def handle_event("paginate", %{"key" => "ArrowRight"}, socket) do
    {:noreply, goto_page(socket, socket.assigns.options.page + 1)}
  end

  def handle_event("paginate", _key, socket) do
    {:noreply, socket}
  end

  defp goto_page(socket, page) when page > 0 do
    push_patch(socket,
      to:
        ~p"/paginate?page=#{socket.assigns.options.page}&per_page=#{socket.assigns.options.per_page}"
    )
  end

  defp goto_page(socket, _page), do: socket

  defp expires_class(donation) do
    if Donations.almost_expired?(donation), do: "eat-now", else: "fresh"
  end

  defp pagination_link(text, page, per_page, class) do
    live_patch(text,
      to: ~p"/paginate?page=#{page}&per_page=#{per_page}",
      class: class
    )
  end
end
