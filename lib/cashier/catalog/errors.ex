defmodule Cashier.Catalog.Errors.FileNotFoundError do
  @moduledoc """
  Custom exception when CSV file is not found.
  """
  defexception [:message]
end

defmodule Cashier.Catalog.Errors.InvalidCSVFormatError do
  @moduledoc """
  Custom exception when CSV file format is invalid.

  Some of the possible reasons for this error are:
  - The file has the wrong headers.
  - The file has invalid data.
  """
  defexception [:message]
end
