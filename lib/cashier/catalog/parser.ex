defmodule Cashier.Catalog.Parser do
  @moduledoc """
  Parser module responsible for parsing and validating CSV files.
  """

  alias NimbleCSV.RFC4180, as: CSV

  alias Cashier.Product
  alias Cashier.Promotion

  alias Cashier.Catalog.Errors.FileNotFoundError
  alias Cashier.Catalog.Errors.InvalidCSVFormatError

  # * headers values are pre-sorted
  @product_headers ~w(name price product_code)
  @promotion_headers ~w(discount product_code promotion_type threshold)

  @doc """
  Loads the products data from the CSV file.\n
  The file must be located at `priv/data/products.csv`.\n
  Parses the CSV file and returns a list of Product structs.\n
  Validates the CSV file format and raises an `InvalidCSVFormatError` if the format is incorrect.\n
  Raises a `FileNotFoundError` if the file is not found.\n
  """
  @spec load_products!() :: [Product.t()] | [] | no_return()
  def load_products!() do
    products_path() |> file_exists?()

    products_path()
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> validate_stream!(@product_headers, 3)
    |> Stream.map(&parse_product_row/1)
    |> Enum.to_list()
  end

  @doc """
  Loads the promotions data from the CSV file.\n
  The file must be located at `priv/data/promotions.csv`.\n
  Parses the CSV file and returns a list of Promotion structs.\n
  Validates the CSV file format and raises an `InvalidCSVFormatError` if the format is incorrect.\n
  Raises a `FileNotFoundError` if the file is not found.\n
  """
  @spec load_promotions!() :: [Promotion.t()] | [] | no_return()
  def load_promotions!() do
    promotions_path() |> file_exists?()

    promotions_path()
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> validate_stream!(@promotion_headers, 4)
    |> Stream.map(&parse_promotion_row/1)
    |> Enum.to_list()
  end

  # * Private helpers

  defp validate_stream!(stream, expected_headers, expected_length) do
    stream
    |> Stream.with_index()
    |> Stream.transform(nil, fn
      {row, 0}, nil ->
        unless Enum.sort(row) == expected_headers do
          message = "CSV headers mismatch! Expected: #{inspect(expected_headers)}, Got: #{inspect(row)}"
          raise InvalidCSVFormatError, message: message
        end

        {[], row}

      {row, _index}, _headers when length(row) != expected_length ->
        message = "Invalid row length! Expected: #{expected_length}, Got: #{length(row)}, Row: #{inspect(row)}"
        raise InvalidCSVFormatError, message: message

      {row, _index}, headers ->
        # * If row has percentage_discount promotion_type, check if percentage is a valid float
        maybe_check_percentage_discount(row)
        {[row], headers}
    end)
  end

  defp maybe_check_percentage_discount(row) do
    if Enum.at(row, 1) == "percentage_discount" do
      discount_str = Enum.at(row, 3)

      # ? Make sure float precision is at least 5 digits after the decimal point
      # ? We are doing this to ensure that the discount is calculated correctly
      case Float.parse(discount_str) do
        {_discount, _} ->
          decimal_part = discount_str |> String.split(".") |> Enum.at(1, "")

          unless String.length(decimal_part) >= 5 do
            message = "Percentage discount must have at least 5 decimal places. Got: #{discount_str}"
            raise InvalidCSVFormatError, message: message
          end

        :error ->
          message = "Invalid float value for percentage discount: #{discount_str}"
          raise InvalidCSVFormatError, message: message
      end
    end
  end

  defp parse_product_row([product_code, name, price]),
    do: %Product{product_code: product_code, name: name, price: String.to_float(price)}

  defp parse_promotion_row([product_code, promotion_type, threshold, discount]) do
    {discount, _} = Float.parse(discount)

    %Promotion{
      product_code: product_code,
      promotion_type: promotion_type,
      threshold: String.to_integer(threshold),
      discount: discount
    }
  end

  defp file_exists?(path), do: File.exists?(path) || raise(FileNotFoundError, message: "File not found: #{path}")

  defp products_path, do: data_dir() |> Path.join("products.csv")
  defp promotions_path, do: data_dir() |> Path.join("promotions.csv")

  defp data_dir, do: :code.priv_dir(:cashier) |> Path.join("data")
end
