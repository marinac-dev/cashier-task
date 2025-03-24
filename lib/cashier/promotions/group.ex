defmodule Cashier.Promotions.Group do
  @moduledoc """
  PromoGroup is a struct that holds grouped items and the promotion that applies to them.
  """

  alias Cashier.Product
  alias Cashier.Promotion

  @enforce_keys [:items, :promotion, :subtotal]
  defstruct [:items, :promotion, :subtotal]

  @type t :: %__MODULE__{
          items: list(%Product{}),
          promotion: %Promotion{},
          subtotal: float()
        }
end
