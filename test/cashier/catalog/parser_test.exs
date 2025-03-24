defmodule Cashier.Catalog.ParserTest do
  use ExUnit.Case, async: true
  import Mock

  alias Cashier.Catalog.Parser
  alias Cashier.Product
  alias Cashier.Promotion
  alias Cashier.Catalog.Errors.FileNotFoundError
  alias Cashier.Catalog.Errors.InvalidCSVFormatError

  # * simulate a file stream from CSV string content.
  defp csv_stream_from_string(csv_content) do
    csv_content
    |> String.split("\n", trim: true)
    |> Stream.map(&(&1 <> "\n"))
  end

  describe "load_products!/0" do
    test "successfully loads valid products CSV" do
      valid_csv = """
      product_code,name,price
      PA,Product A,10.0
      PB,Product B,20.0
      """

      with_mock File, [:passthrough],
        exists?: fn _path -> true end,
        stream!: fn _path -> csv_stream_from_string(valid_csv) end do
        products = Parser.load_products!()
        assert length(products) == 2
        assert Enum.all?(products, fn p -> %Product{} = p end)

        [p1, p2] = products
        assert p1.product_code == "PA"
        assert p1.name == "Product A"
        assert p1.price == 10.0
        assert p2.product_code == "PB"
        assert p2.name == "Product B"
        assert p2.price == 20.0
      end
    end

    test "raises FileNotFoundError when products CSV is not found" do
      with_mock File, [:passthrough], exists?: fn _path -> false end do
        assert_raise FileNotFoundError, fn ->
          Parser.load_products!()
        end
      end
    end

    test "raises InvalidCSVFormatError for header mismatch in products CSV" do
      # The expected sorted headers are: ["name", "price", "product_code"]
      invalid_header_csv = """
      wrong,header,order
      PA,Product A,10.0
      """

      with_mock File, [:passthrough],
        exists?: fn _path -> true end,
        stream!: fn _path -> csv_stream_from_string(invalid_header_csv) end do
        assert_raise InvalidCSVFormatError, ~r/CSV headers mismatch!/, fn ->
          Parser.load_products!()
        end
      end
    end

    test "raises InvalidCSVFormatError for invalid row length in products CSV" do
      # Second row only has two columns instead of three.
      invalid_row_csv = """
      product_code,name,price
      PA,Product A
      """

      with_mock File, [:passthrough],
        exists?: fn _path -> true end,
        stream!: fn _path -> csv_stream_from_string(invalid_row_csv) end do
        assert_raise InvalidCSVFormatError, ~r/Invalid row length!/, fn ->
          Parser.load_products!()
        end
      end
    end
  end

  describe "load_promotions!/0" do
    test "successfully loads valid promotions CSV" do
      valid_csv = """
      discount,product_code,promotion_type,threshold
      PB,BOGO,2,5.0
      """

      with_mock File, [:passthrough],
        exists?: fn _path -> true end,
        stream!: fn _path -> csv_stream_from_string(valid_csv) end do
        promotions = Parser.load_promotions!()
        assert length(promotions) == 1

        [promo] = promotions
        assert %Promotion{} = promo
        assert promo.product_code == "PB"
        assert promo.promotion_type == "BOGO"
        assert promo.threshold == 2
        assert promo.discount == 5.0
      end
    end

    test "raises FileNotFoundError when promotions CSV is not found" do
      with_mock File, [:passthrough], exists?: fn _path -> false end do
        assert_raise FileNotFoundError, fn ->
          Parser.load_promotions!()
        end
      end
    end

    test "raises InvalidCSVFormatError for header mismatch in promotions CSV" do
      # Expected sorted headers for promotions: ["discount", "product_code", "promotion_type", "threshold"]
      invalid_header_csv = """
      wrong,header,order,columns
      PB,BOGO,2,5.0
      """

      with_mock File, [:passthrough],
        exists?: fn _path -> true end,
        stream!: fn _path -> csv_stream_from_string(invalid_header_csv) end do
        assert_raise InvalidCSVFormatError, ~r/CSV headers mismatch!/, fn ->
          Parser.load_promotions!()
        end
      end
    end

    test "raises InvalidCSVFormatError for invalid row length in promotions CSV" do
      # Second row only has three columns instead of four.
      invalid_row_csv = """
      discount,product_code,promotion_type,threshold
      PB,BOGO,2
      """

      with_mock File, [:passthrough],
        exists?: fn _path -> true end,
        stream!: fn _path -> csv_stream_from_string(invalid_row_csv) end do
        assert_raise InvalidCSVFormatError, ~r/Invalid row length!/, fn ->
          Parser.load_promotions!()
        end
      end
    end
  end
end
