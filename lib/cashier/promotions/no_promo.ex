defmodule Cashier.Promotions.NoPromo do
  @moduledoc """
  No-op promotion module.
  """
  alias Cashier.Promotions.Group

  @behaviour Cashier.Promotion

  def applicable?(_, _) do
    true
  end

  def apply_promotion(products, _promotion) do
    sum = Enum.sum_by(products, & &1.price)
    %Group{promotion: nil, items: products, subtotal: sum}
  end
end
