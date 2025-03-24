defmodule CashierWeb.PageLive do
  alias Cashier.Checkout
  use CashierWeb, :live_view

  alias Cashier.Catalog

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:cart, [])
      |> assign(:checkout, [])
      |> assign(:products, Catalog.get_products())
      |> assign(:promotions, Catalog.get_promotions())

    {:ok, socket}
  end

  def handle_event("add", %{"product_code" => product_code}, %{assigns: assign} = socket) do
    p = Catalog.get_product_by_code(product_code)
    cart = assign.cart ++ [p]
    checkout = Checkout.checkout_products(cart)

    socket =
      socket
      |> assign(:cart, cart)
      |> assign(:checkout, checkout)

    {:noreply, assign(socket, cart: cart)}
  end

  def handle_event("decrement", %{"product_code" => product_code}, socket) do
    new_cart = remove_first_product(socket.assigns.cart, product_code)
    checkout = Checkout.checkout_products(new_cart)

    socket =
      socket
      |> assign(:cart, new_cart)
      |> assign(:checkout, checkout)

    {:noreply, socket}
  end

  def handle_event("remove", %{"product_code" => product_code}, socket) do
    new_cart = Enum.reject(socket.assigns.cart, fn p -> p.code == product_code end)
    checkout = Checkout.checkout_products(new_cart)

    socket =
      socket
      |> assign(:cart, new_cart)
      |> assign(:checkout, checkout)

    {:noreply, socket}
  end

  # * Private helpers

  defp remove_first_product([], _product_code), do: []

  defp remove_first_product([head | tail], product_code) do
    if head.product_code == product_code do
      tail
    else
      [head | remove_first_product(tail, product_code)]
    end
  end
end
