defmodule Cashier.Catalog.CsvAgentTest do
  use ExUnit.Case, async: true

  test "get_products returns all products" do
    products = Cashier.Catalog.get_products()
    assert length(products) == 4
  end

  test "get_promotions returns all promotions" do
    promotions = Cashier.Catalog.get_promotions()
    assert length(promotions) == 3
  end

  test "refresh_catalog returns :ok" do
    assert Cashier.Catalog.refresh_catalog() == :ok
  end

  test "get_product_by_code returns product when it exists" do
    product = Cashier.Catalog.get_product_by_code("GR1")
    refute is_nil(product)
    assert product.product_code == "GR1"
  end

  test "get_product_by_code returns nil when product does not exist" do
    product = Cashier.Catalog.get_product_by_code("X999")
    assert is_nil(product)
  end

  test "get_promotion_by_code returns promotion when it exists" do
    promotion = Cashier.Catalog.get_promotion_by_code("GR1")
    refute is_nil(promotion)
    assert promotion.product_code == "GR1"
  end

  test "get_promotion_by_code returns nil when promotion does not exist" do
    promotion = Cashier.Catalog.get_promotion_by_code("X999")
    assert is_nil(promotion)
  end
end
