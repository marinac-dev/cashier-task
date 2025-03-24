defmodule Cashier.Catalog do
  @moduledoc """
  This module is responsible for managing the catalog of products and promotions.
  """

  alias Cashier.Catalog.CsvAgent
  alias Cashier.Product
  alias Cashier.Promotion

  @doc """
  Get all products from the catalog.
  """
  @spec get_products() :: [Product.t()]
  def get_products do
    CsvAgent.get_products()
  end

  @doc """
  Get all promotions from the catalog.
  """
  @spec get_promotions() :: [Promotion.t()]
  def get_promotions do
    CsvAgent.get_promotions()
  end

  @doc """
  Refresh the catalog by reloading the CSV file.
  """
  @spec refresh_catalog() :: :ok
  def refresh_catalog do
    CsvAgent.reload()
  end

  @doc """
  Get a product by its product code.
  """
  @spec get_product_by_code(String.t()) :: Product.t() | nil
  def get_product_by_code(product_code) do
    products = get_products()
    Enum.find(products, fn product -> product.product_code == product_code end)
  end

  @doc """
  Get a promotion by its product code.
  """
  @spec get_promotion_by_code(String.t()) :: Promotion.t() | nil
  def get_promotion_by_code(promotion_code) do
    promotions = get_promotions()
    Enum.find(promotions, fn promotion -> promotion.product_code == promotion_code end)
  end
end
