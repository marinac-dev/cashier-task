defmodule Cashier.Promotion do
  @moduledoc """
  This module is responsible for managing and applying promotional discounts.

  It defines a behaviour for registering promotions to products.
  """

  alias Cashier.Product
  alias Cashier.Promotions.Group

  @enforce_keys [:product_code, :promotion_type, :threshold, :discount]
  defstruct [:product_code, :promotion_type, :threshold, :discount]

  @type t :: %__MODULE__{
          product_code: String.t(),
          promotion_type: String.t(),
          threshold: non_neg_integer(),
          discount: float()
        }

  @doc """
  Applies a promotion to a product given the quantity purchased.

  Returns the discounted price after applying the promotion.
  """
  @callback apply_promotion(products :: list(%Product{}), promotion :: %__MODULE__{}) :: %Group{}

  @doc """
  Checks if a promotion is applicable to a product given the quantity purchased.

  Returns true if the promotion is applicable, otherwise false.
  """
  @callback applicable?(products :: list(%Product{}), promotion :: %__MODULE__{}) :: boolean()
end
