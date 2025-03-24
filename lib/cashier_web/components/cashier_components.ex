defmodule CashierWeb.CashierComponents do
  @moduledoc """
  Provides core UI components for Cashier UI.
  """

  use Phoenix.Component
  use Gettext, backend: CashierWeb.Gettext

  alias Phoenix.LiveView.JS

  import CashierWeb.CoreComponents

  attr :product, :map, required: true

  def product_item(assigns) do
    ~H"""
    <div class="product-card">
      <div class="p-4">
        <div class="poster">
          <img
            src={"https://placehold.co/120/EEEEEE/31343C.webp?font=lato&text=#{@product.name}"}
            alt="{@product.name}"
            class="block dark:hidden"
          />
          <img
            src={"https://placehold.co/120/31343c/EEEEEE.webp?font=lato&text=#{@product.name}"}
            alt="{@product.name}"
            class="hidden dark:block"
          />
        </div>

        <h3 class="font-medium">{@product.name}</h3>
        <p class="text-gray-500 text-sm">{@product.product_code}</p>

        <div class="flex justify-between items-center mt-3">
          <span class="font-medium">${@product.price}</span>

          <button
            type="button"
            class="add-to-cart"
            phx-click={
              JS.push("add", value: %{product_code: @product.product_code})
              |> JS.remove_class("translate-x-full", to: "#cart-sidebar")
            }
          >
            <.icon name="hero-plus w-5 h-5 text-white" />
          </button>
        </div>
      </div>
    </div>
    """
  end

  attr :group, :map, required: true

  def cart_item(assigns) do
    ~H"""
    <div class="item">
      <div class="flex items-center">
        <div class="mr-3">
          <button class="decrement" phx-click={JS.push("decrement", value: %{product_code: get_p_code(@group)})}>
            <.icon name="hero-minus" class="w-4 h-4" />
          </button>
        </div>
        <div>
          <div class="font-medium">{get_p_name(@group)}</div>

          <div :if={@group.promotion && @group.promotion.promotion_type == "buy_one_get_one_free"} class="text-gray-500 text-sm">
            ${get_p_og_price(@group)} × {get_p_count(@group)}
          </div>

          <div :if={@group.promotion && @group.promotion.promotion_type == "bulk_discount"} class="text-gray-500 text-sm">
            ${get_p_price(@group)} × {get_p_count(@group)}
          </div>

          <div :if={@group.promotion && @group.promotion.promotion_type == "percentage_discount"} class="text-gray-500 text-sm">
            ${get_p_price(@group)} × {get_p_count(@group)}
          </div>

          <div :if={@group.promotion == nil} class="text-gray-500 text-sm">
            ${get_p_price(@group)} × {get_p_count(@group)}
          </div>
        </div>
      </div>
      <div class="flex items-center">
        <span class="mr-3">{Float.round(@group.subtotal, 2)}</span>
        <button class="remove" phx-click={JS.push("remove", value: %{product_code: get_p_code(@group)})}>
          <.icon name="hero-x-mark" class="w-4 h-4" />
        </button>
      </div>
    </div>
    """
  end

  def get_p_name(%{items: [product | _]}), do: product.name
  def get_p_code(%{items: [product | _]}), do: product.product_code
  def get_p_price(%{items: [product | _]}), do: product.price
  def get_p_og_price(%{items: [product | _]}), do: product.original_price
  def get_p_count(%{items: items}), do: length(items)
end
