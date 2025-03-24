defmodule Cashier.Promotions.BulkDiscount do
  @moduledoc """
  Implements the Bulk Discount promotion.

  This promotion applies a discount to the price of a product when a certain quantity is purchased.
  """

  @behaviour Cashier.Promotion

  alias Cashier.Product
  alias Cashier.Promotion

  alias Cashier.Promotions.Group

  @doc """
  Checks if the promotion is applicable based on the provided threshold.
  """
  def applicable?(products, %Promotion{threshold: threshold}) do
    length(products) >= threshold
  end

  @doc """
  Applies the Bulk Discount promotion by applying a discount to the price of a product.
  """

  def apply_promotion(products, %Promotion{discount: new_price} = promo) do
    promo_group = %Group{promotion: promo, items: [], subtotal: 0.0}

    products
    |> Enum.reduce(promo_group, fn product, acc ->
      p = %Product{product | price: new_price, original_price: product.price}
      %{acc | items: [p | acc.items], subtotal: acc.subtotal + p.price}
    end)
  end
end
