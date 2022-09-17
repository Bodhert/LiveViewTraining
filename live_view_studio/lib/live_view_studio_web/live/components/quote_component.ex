defmodule LiveViewStudioWeb.QuoteComponent do
  use Phoenix.Component

  import Number.Currency

  def quote(assigns) do
    ~H"""
    <div class="text-center p-6 border-4 border-dashed border-indigo-600">
      <h2 class="text-2xl mb-2">
        our Best Deal:
      </h2>
      <h3 class="text-xl font-semibold text-indigo-600">
        <%= @weight %> pounds of <%= @material %> for
        <%= number_to_currency(@price) %> plus <%= number_to_currency(@charge) %>
        delivery
      </h3>
      <div class="text-gray-600">
        expires in <%= @hrs_until_expires %> hours
      </div>
    </div>
    """
  end
end
