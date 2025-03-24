defmodule Cashier.Product do
  @moduledoc """
  Product module is core of the Cashier system, it defines the product schema and its changeset.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          product_code: String.t(),
          name: String.t(),
          price: float(),
          original_price: float()
        }

  @primary_key false
  embedded_schema do
    field :product_code, :string
    field :name, :string
    field :price, :decimal
    field :original_price, :decimal
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:product_code, :name, :price])
    |> validate_required([:product_code, :name, :price])
  end
end
