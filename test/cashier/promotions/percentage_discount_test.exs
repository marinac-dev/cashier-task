defmodule Cashier.Promotions.PercentageDiscountTest do
  use ExUnit.Case, async: true

  alias Cashier.Product
  alias Cashier.Promotion
  alias Cashier.Promotions.PercentageDiscount

  defp p(price), do: %Product{product_code: "CF1", name: "Coffee", price: price}

  test "applies percentage discount when threshold met" do
    promo = %Promotion{product_code: "CF1", promotion_type: :percentage_discount, threshold: 3, discount: 0.33}
    products = [p(11.23), p(11.23), p(11.23)]
    sum_start = Enum.sum_by(products, & &1.price)

    result = PercentageDiscount.apply_promotion(products, promo)

    assert result.subtotal == Float.round(sum_start * 0.67, 2)

    assert PercentageDiscount.applicable?(products, promo)
  end

  test "not applicable below threshold" do
    promo = %Promotion{product_code: "CF1", promotion_type: :percentage_discount, threshold: 3, discount: 0.5}
    products = [p(11.23), p(11.23)]

    refute PercentageDiscount.applicable?(products, promo)
  end
end
