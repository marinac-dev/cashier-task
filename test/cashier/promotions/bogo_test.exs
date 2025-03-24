defmodule Cashier.Promotions.BogoTest do
  use ExUnit.Case, async: true

  alias Cashier.Product
  alias Cashier.Promotion
  alias Cashier.Promotions.Bogo

  defp p(code, price), do: %Product{product_code: code, name: "Green Tea", price: price}

  test "applies BOGO: 3 items => 2 paid, 1 free" do
    promo = %Promotion{product_code: "GR1", promotion_type: :buy_one_get_one_free, threshold: 1, discount: 0}
    products = [p("GR1", 3.11), p("GR1", 3.11), p("GR1", 3.11)]

    result = Bogo.apply_promotion(products, promo)
    prices = Enum.map(result.items, & &1.price)

    assert result.subtotal == 6.22
    assert Enum.sort(prices) == [0.0, 3.11, 3.11]
    assert Bogo.applicable?(products, promo)
  end

  test "applies BOGO: 2 items => 1 paid, 1 free" do
    promo = %Promotion{product_code: "GR1", promotion_type: :buy_one_get_one_free, threshold: 1, discount: 0}
    products = [p("GR1", 3.11), p("GR1", 3.11)]

    result = Bogo.apply_promotion(products, promo)
    prices = Enum.map(result.items, & &1.price)

    assert result.subtotal == 3.11
    assert Enum.sort(prices) == [0.0, 3.11]
    assert Bogo.applicable?(products, promo)
  end

  test "not applicable when below threshold" do
    promo = %Promotion{product_code: "GR1", promotion_type: :buy_one_get_one_free, threshold: 4, discount: 0}
    products = [p("GR1", 3.11), p("GR1", 3.11)]

    refute Bogo.applicable?(products, promo)
  end
end
