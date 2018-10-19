defmodule ValidationTest do
  use ExUnit.Case
  # doctest BankAccount

  test "can verify transactions" do
    data = Shared.account_data()
    assert :ok == BankAccount.Validation.verify_transactions(data)
  end

end