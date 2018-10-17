defmodule DeutscheBankKontoumsaetzeCsvTest do
  use ExUnit.Case
  # doctest BankAccount

  test "can parse line 0 with of account_title persönliches Konto" do
    line = "Umsätze persönliches Konto (00);;;Kundennummer: 123 1234567"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(0, line)
    assert result == {0, %{account_index: "00", account_number: "1234567", account_title: "persönliches Konto", branch_number: "123"}}
  end

  test "can parse line 0 with of account_title SparCard" do
    line = "Umsätze SparCard (00);;;Kundennummer: 123 1234567"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(0, line)
    assert result == {0, %{account_index: "00", account_number: "1234567", account_title: "SparCard", branch_number: "123"}}
  end

  test "can parse line 1 with valid time string" do
    line = "27.10.2016 - 21.04.2017"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(1, line)
    assert result == {1, %{end_date: "21.04.2017", start_date: "27.10.2016"}}
  end
end