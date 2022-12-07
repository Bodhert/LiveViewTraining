defmodule LiveViewStudioWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  def live_modal(component, opts) do
    live_component(
      LiveViewStudioWeb.ModalComponent,
      id: :modal,
      component: component,
      return_to: Keyword.fetch!(opts, :return_to),
      opts: opts
    )
  end
end
