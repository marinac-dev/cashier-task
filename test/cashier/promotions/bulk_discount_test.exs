defmodule Cashier.Promotions.BulkDiscountTest do
  use ExUnit.Case, async: true

  alias Cashier.Product
  alias Cashier.Promotion
  alias Cashier.Promotions.BulkDiscount

  defp p(price), do: %Product{product_code: "SR1", name: "Strawberries", price: price}

  test "applies bulk discount when threshold met" do
    promo = %Promotion{product_code: "SR1", promotion_type: :bulk_discount, threshold: 3, discount: 4.50}
    products = [p(5.00), p(5.00), p(5.00)]
    sum_start = Enum.sum_by(products, & &1.price)

    result = BulkDiscount.apply_promotion(products, promo)
    prices = Enum.map(result.items, & &1.price)
    sum_end = Enum.sum_by(result.items, & &1.price)

    assert prices == [4.50, 4.50, 4.50]
    assert sum_start > sum_end
    assert BulkDiscount.applicable?(products, promo)
  end

  test "not applicable when below threshold" do
    promo = %Promotion{product_code: "SR1", promotion_type: :bulk_discount, threshold: 3, discount: 4.50}
    products = [p(5.00), p(5.00)]

    refute BulkDiscount.applicable?(products, promo)
  end
end
