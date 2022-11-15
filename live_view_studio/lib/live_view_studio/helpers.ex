defmodule LiveViewStudio.Helpers do
  use LiveViewStudioWeb, :live_component

  def param_of_first_permitted(params, key, permitted) do
    value = params[key]
    if value in permitted, do: value, else: hd(permitted)
  end

  def param_to_integer(nil, default_value), do: default_value

  def param_to_integer(param, default_value) do
    case Integer.parse(param) do
      {number, _} ->
        number

      :error ->
        default_value
    end
  end

  def pagination_link(socket, module, text, page, options, class) do
    live_patch(text,
      to:
        Routes.live_path(
          socket,
          module,
          page: page,
          per_page: options.per_page,
          sort_by: options.sort_by,
          sort_order: options.sort_order
        ),
      class: class
    )
  end

  def sort_link(socket, module, text, sort_by, options) do
    text =
      if sort_by == options.sort_by do
        text <> emoji(options.sort_order)
      else
        text
      end

    live_patch(text,
      to:
        Routes.live_path(
          socket,
          module,
          sort_by: sort_by,
          sort_order: toggle_sort_order(options.sort_order),
          page: options.page,
          per_page: options.per_page
        )
    )
  end

  def render(assigns) do
    ~H"""
    """
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc

  defp emoji(:asc), do: "☝️"
  defp emoji(:desc), do: "👇"
end
