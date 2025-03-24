defmodule Cashier.Promotions.PercentageDiscount do
  @moduledoc """
  Implements the Percentage Discount promotion.

  This promotion applies a percentage discount to the price of a product.
  """

  @behaviour Cashier.Promotion

  alias Cashier.Promotion

  alias Cashier.Promotions.Group

  @doc """
  Checks if the promotion is applicable based on the provided threshold.
  """
  def applicable?(products, %Promotion{threshold: threshold}) do
    length(products) >= threshold
  end

  @doc """
  Applies the Percentage Discount promotion by applying a percentage discount to the price of a product.
  """
  def apply_promotion(products, %Promotion{discount: discount_fraction} = promotion) do
    promo_group = %Group{promotion: promotion, items: [], subtotal: 0.0}

    Enum.reduce(products, promo_group, fn product, acc ->
      est_price = Float.round(product.price * (1 - discount_fraction), 2)
      p = %{product | price: est_price, original_price: product.price}
      %{acc | items: [p | acc.items], subtotal: acc.subtotal + product.price}
    end)
    |> Map.update!(:subtotal, fn subtotal ->
      Float.round(subtotal * (1 - discount_fraction), 2)
    end)
  end
end
