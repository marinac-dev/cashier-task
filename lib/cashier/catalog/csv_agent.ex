defmodule Cashier.Catalog.CsvAgent do
  @moduledoc """
  Agent module responsible for product and promotion data management from CSV files.
  """

  use Agent
  alias Cashier.Catalog.Parser

  def start_link(_opts) do
    Agent.start_link(fn -> load_catalog() end, name: __MODULE__)
  end

  def reload do
    Agent.update(__MODULE__, fn _ -> load_catalog() end)
  end

  defp load_catalog do
    %{
      products: Parser.load_products!(),
      promotions: Parser.load_promotions!()
    }
  end

  def get_products, do: Agent.get(__MODULE__, & &1.products)
  def get_promotions, do: Agent.get(__MODULE__, & &1.promotions)
end
