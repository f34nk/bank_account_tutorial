defmodule BankAccountTest do
  use ExUnit.Case
  # doctest BankAccount

  test "import Deutsche Bank csv" do
    filepath = "test/fixtures/Kontoumsaetze_persoenliches_Konto.csv"
    assert {:ok, imported} = BankAccount.import("Deutsche Bank", filepath)

    last_balance = Map.get(imported, :last_balance)
    current_balance = Map.get(imported, :current_balance)
    assert last_balance == "1.999,99"
    assert current_balance == "2.770,81"
  end

end