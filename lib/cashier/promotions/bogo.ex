defmodule Cashier.Promotions.Bogo do
  @moduledoc """
  Implements the "Buy One Get One" (BOGO) promotion, its flexible and not limited to one product limit as the name suggests.

  This promotion makes every item after a certain threshold free, and this pattern repeats.

  **Note**: Module requires that the producs provided are of **same** product code.

  ## Example
      # This is a valid example
      promo = %Promotion{product_code: "GR1", promotion_type: :buy_one_get_one_free, threshold: 1, discount: 0}
      products = [p("GR1", 3.11), p("GR1", 3.11), p("GR1", 3.11)]
      Bogo.apply_promotion(products, promo)

      # This is an invalid example
      promo = %Promotion{product_code: "GR1", promotion_type: :buy_one_get_one_free, threshold: 1, discount: 0}
      products = [p("GR1", 3.11), p("GR2", 3.11), p("GR1", 3.11)]
      Bogo.apply_promotion(products, promo)
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
  Applies the BOGO promotion by making every x item free.
  """
  @spec apply_promotion([Product.t()], Promotion.t()) :: Group.t()
  def apply_promotion([first | _] = products, %{threshold: threshold} = promotion) do
    price = first.price
    promo_group = %Group{promotion: promotion, items: [], subtotal: 0.0}

    products
    |> Enum.with_index()
    |> Enum.reduce(promo_group, fn {product, index}, acc ->
      p =
        if rem(index, threshold + 1) == threshold,
          do: %Product{product | price: 0.0, original_price: price},
          else: %Product{product | price: price, original_price: price}

      %{acc | items: [p | acc.items], subtotal: acc.subtotal + p.price}
    end)
  end
end
