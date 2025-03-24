defmodule Cashier.Promotions.DispatcherTest do
  use ExUnit.Case, async: true

  alias Cashier.Product
  alias Cashier.Promotion
  alias Cashier.Promotions.Dispatcher
  alias Cashier.Promotions.Bogo

  defp p(code, price), do: %Product{product_code: code, name: "Green Tea", price: price}

  test "returns no promotion if promotion is nil" do
    products = [p("GR1", 3.11), p("GR1", 3.11)]
    result = Dispatcher.apply(products, nil)

    assert result.promotion == nil
    assert result.items == products
    assert_in_delta result.subtotal, 6.22, 0.001
  end

  test "dispatches to Bogo when promotion type is buy_one_get_one_free and applicable" do
    promo = %Promotion{
      product_code: "GR1",
      promotion_type: "buy_one_get_one_free",
      threshold: 1,
      discount: 0
    }

    products = [p("GR1", 3.11), p("GR1", 3.11)]
    result = Dispatcher.apply(products, promo)

    prices = Enum.map(result.items, fn prod -> prod.price end)
    assert_in_delta result.subtotal, 3.11, 0.001
    assert Enum.sort(prices) == [0.0, 3.11]
    assert Bogo.applicable?(products, promo)
  end

  test "dispatches to no promotion when Bogo is not applicable" do
    promo = %Promotion{
      product_code: "GR1",
      promotion_type: "buy_one_get_one_free",
      threshold: 4,
      discount: 0
    }

    products = [p("GR1", 3.11), p("GR1", 3.11)]
    result = Dispatcher.apply(products, promo)

    # Returns default NoPromo promotion result.
    assert result.promotion == nil
    assert result.items == products
    assert_in_delta result.subtotal, 6.22, 0.001
    refute Bogo.applicable?(products, promo)
  end

  test "dispatches to no promotion for unknown promotion type" do
    promo = %Promotion{
      product_code: "GR1",
      promotion_type: "unknown",
      threshold: 1,
      discount: 0
    }

    products = [p("GR1", 3.11)]
    result = Dispatcher.apply(products, promo)

    # Unknown promotion type triggers error log and defaults to NoPromo.
    assert result.promotion == nil
    assert result.items == products
    assert_in_delta result.subtotal, 3.11, 0.001
  end
end
