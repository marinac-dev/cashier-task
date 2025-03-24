defmodule Cashier.Promotions.NoPromoTest do
  use ExUnit.Case, async: true

  alias Cashier.Promotions.NoPromo

  defp p(code, price), do: %{product_code: code, name: "Test Product", price: price}

  test "applies no promotion correctly" do
    products = [p("P1", 5.00), p("P2", 10.00), p("P3", 3.50)]
    expected_sum = Enum.sum_by(products, & &1.price)

    result = NoPromo.apply_promotion(products, nil)

    assert result.promotion == nil
    assert result.items == products
    assert result.subtotal == expected_sum
  end

  test "applicable? always returns true" do
    products = [p("P1", 5.00)]
    refute is_nil(NoPromo.applicable?(products, nil))
    assert NoPromo.applicable?(products, nil)
  end
end
