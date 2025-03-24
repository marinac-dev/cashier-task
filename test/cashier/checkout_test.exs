defmodule Cashier.CheckoutTest do
  use ExUnit.Case, async: true

  alias Cashier.Checkout

  test "GR1,SR1,GR1,GR1,CF1 => 22.45" do
    result = Checkout.checkout(["GR1", "SR1", "GR1", "GR1", "CF1"])
    assert result == 22.45
  end

  test "GR1,GR1 => 3.11" do
    result = Checkout.checkout(["GR1", "GR1"])
    assert result == 3.11
  end

  test "SR1,SR1,GR1,SR1 => 16.61" do
    result = Checkout.checkout(["SR1", "SR1", "GR1", "SR1"])
    assert result == 16.61
  end

  test "GR1,CF1,SR1,CF1,CF1 => 30.57" do
    result = Checkout.checkout(["GR1", "CF1", "SR1", "CF1", "CF1"])
    assert result == 30.57
  end
end
