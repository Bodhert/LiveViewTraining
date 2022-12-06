defmodule LiveViewStudioWeb.CreaturesComponent do
  use LiveViewStudioWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <h2><%= Keyword.get(@opts, :title) %></h2>
      <div class="creatures">
        🐙 🐳 🦑 🐡 🐚 🐋 🐟 🦈 🐠 🦀 🐬
      </div>
      <%= live_patch("I'm outta air!", to: Keyword.get(@opts, :return_to), class: "button") %>
    </div>
    """
  end
end
