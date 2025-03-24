defmodule Cashier.Checkout do
  @moduledoc """
  Checkout module is responsible for calculating the total price of the products in the cart.
  It applies the promotions to the products and calculates the total price.

  Currently supports only one promotion per product.

  ## Example
      Checkout.checkout(["GR1", "SR1", "GR1", "GR1", "CF1"])
      > 22.45
  """

  alias Cashier.Catalog
  alias Cashier.Product
  alias Cashier.Promotions.Dispatcher

  @spec checkout([String.t()]) :: float()
  def checkout(codes) when is_list(codes) do
    products = Catalog.get_products()
    promotions = Catalog.get_promotions()

    codes
    |> codes_to_products(products)
    |> apply_promotions(promotions)
    |> Enum.sum_by(& &1.subtotal)
    |> Float.round(2)
  end

  def checkout_products(products) do
    promotions = Catalog.get_promotions()
    apply_promotions(products, promotions)
  end

  defp apply_promotions(products, promotions) do
    products
    |> Enum.group_by(& &1.product_code)
    |> Enum.map(fn {code, items} ->
      promo = Enum.find(promotions, &(&1.product_code == code))
      Dispatcher.apply(items, promo)
    end)
  end

  defp codes_to_products(codes, products) do
    Enum.map(codes, &find_product(&1, products))
  end

  defp find_product(code, products) do
    Enum.find(products, fn %Product{product_code: c} -> c == code end)
  end
end
