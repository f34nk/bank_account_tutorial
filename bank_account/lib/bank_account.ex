defmodule BankAccount do
  @moduledoc """
  Simple package to handle a Bank Account.
  """

  @doc """
  Import account file from "Deutsche Bank".

  ## Examples

      iex> BankAccount.import("Deutsche Bank", "test")
      {:error, "No importer found for file: test"}

  """
  def import("Deutsche Bank", filepath) when not is_nil(filepath) do

    filename = Path.basename(filepath)

    cond do
      Path.extname(filepath) == ".csv" and String.starts_with?(filename, "Kontoumsaetze_") ->
        DeutscheBankKontoumsaetzeCsv.import(filepath)
      Path.extname(filepath) == ".csv" and String.starts_with?(filename, "Kreditkartentransaktionen") ->
        DeutscheBankKreditkartentransaktionenCsv.import(filepath)
      true -> {:error, "No importer found for file: #{filepath}"}
    end

  end
end
