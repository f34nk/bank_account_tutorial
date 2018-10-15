defmodule BankAccountTest do
  use ExUnit.Case
  # doctest BankAccount

  test "import Deutsche Bank persönliches Konto csv" do
    filepath = "test/fixtures/Kontoumsaetze_persoenliches_Konto.csv"
    assert {:ok, imported} = BankAccount.import("Deutsche Bank", filepath)

    account_title = Map.get(imported, :account_title)
    last_balance = Map.get(imported, :last_balance)
    current_balance = Map.get(imported, :current_balance)

    assert account_title == "persönliches Konto"
    assert last_balance == "1.999,99"
    assert current_balance == "2.770,81"
  end

  test "import Deutsche Bank SparCard csv" do
    filepath = "test/fixtures/Kontoumsaetze_SparCard.csv"
    assert {:ok, imported} = BankAccount.import("Deutsche Bank", filepath)

    account_title = Map.get(imported, :account_title)
    last_balance = Map.get(imported, :last_balance)
    current_balance = Map.get(imported, :current_balance)

    assert account_title == "SparCard"
    assert last_balance == "1.999,99"
    assert current_balance == "2.150,14"
  end

  test "import Deutsche Bank Kreditkartentransaktionen csv" do
    filepath = "test/fixtures/Kreditkartentransaktionen123456789_20140312.csv"
    assert {:ok, imported} = BankAccount.import("Deutsche Bank", filepath)

    account_title = Map.get(imported, :account_title)
    current_balance = Map.get(imported, :current_balance)

    assert account_title == "Kreditkartentransaktionen"

    assert current_balance == "-41,80"
  end

end