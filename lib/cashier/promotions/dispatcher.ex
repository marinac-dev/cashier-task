defmodule Cashier.Promotions.Dispatcher do
  @moduledoc """
  Helper module for dispatching promotions based on their type.
  """

  require Logger

  alias Cashier.Promotion
  alias Cashier.Promotions.Bogo
  alias Cashier.Promotions.BulkDiscount
  alias Cashier.Promotions.PercentageDiscount
  alias Cashier.Promotions.NoPromo

  def apply(products, nil) do
    NoPromo.apply_promotion(products, nil)
  end

  def apply(products, %Promotion{promotion_type: promotion_type} = promo) do
    case promotion_type do
      "buy_one_get_one_free" ->
        if Bogo.applicable?(products, promo) do
          Bogo.apply_promotion(products, promo)
        else
          NoPromo.apply_promotion(products, nil)
        end

      "bulk_discount" ->
        if BulkDiscount.applicable?(products, promo) do
          BulkDiscount.apply_promotion(products, promo)
        else
          NoPromo.apply_promotion(products, nil)
        end

      "percentage_discount" ->
        if PercentageDiscount.applicable?(products, promo) do
          PercentageDiscount.apply_promotion(products, promo)
        else
          NoPromo.apply_promotion(products, nil)
        end

      _ ->
        Logger.error("Unknown promotion type: #{promotion_type}")
        NoPromo.apply_promotion(products, nil)
    end
  end
end
