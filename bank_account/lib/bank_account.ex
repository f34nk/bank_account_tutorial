defmodule BankAccount do
  @moduledoc """
  Simple package to handle a Bank Account.
  """

  @doc """
  Import account file from "Deutsche Bank".

  ## Examples

      iex> BankAccount.import("Deutsche Bank", "test")
      {:error, "No importer found for file test"}

  """
  def import("Deutsche Bank", filepath) when not is_nil(filepath) do
    case Path.extname(filepath) do
      ".csv" -> DeutscheBankKontoumsaetzeCsv.import(filepath)
      _ -> {:error, "No importer found for file #{filepath}"}
    end
  end
end
