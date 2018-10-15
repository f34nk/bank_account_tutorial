defmodule DeutscheBankKontoumsaetzeCsvTest do
  use ExUnit.Case
  # doctest BankAccount

  test "can parse valid line 0" do
    line = "Umsätze persönliches Konto (00);;;Kundennummer: 123 1234567"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(0, line)
    assert result == {0, %{account_index: "00", account_number: "1234567", account_title: "persönliches Konto", branch_number: "123"}}
  end

  test "can parse line 0 with invalid account account_title" do
    line = "Lorem ipsum (00);;;Kundennummer: 123 1234567"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(0, line)
    assert result == {:error, "Failed to parse line 0"}
  end

  test "can parse line 0 with invalid account_index" do
    line = "Umsätze persönliches Konto (00);;;Kundennummer: 123 1234567"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(0, line)
    assert result == {0, %{account_index: "00", account_number: "1234567", account_title: "persönliches Konto", branch_number: "123"}}
  end

  test "can parse line 0 with invalid text" do
    line = "Umsätze persönliches Konto (00);;;Lorem ipsum: 123 1234567"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(0, line)
    assert result == {:error, "Failed to parse line 0"}
  end

  test "can parse line 0 with invalid branch_number (too short)" do
    line = "Umsätze persönliches Konto (00);;;Kundennummer: 1 1234567"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(0, line)
    assert result == {:error, "Failed to parse line 0"}
  end

  test "can parse line 0 with invalid branch_number (too long)" do
    line = "Umsätze persönliches Konto (00);;;Kundennummer: 1234 1234567"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(0, line)
    assert result == {:error, "Failed to parse line 0"}
  end

  test "can parse line 0 with invalid account_number (too short)" do
    line = "Umsätze persönliches Konto (00);;;Lorem ipsum: 123 123"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(0, line)
    assert result == {:error, "Failed to parse line 0"}
  end

  test "can parse line 0 with invalid account_number (too long)" do
    line = "Umsätze persönliches Konto (00);;;Lorem ipsum: 123 12345678"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(0, line)
    assert result == {:error, "Failed to parse line 0"}
  end

  test "can parse line 1 with valid time string" do
    line = "27.10.2016 - 21.04.2017"
    result = DeutscheBankKontoumsaetzeCsv.parse_line(1, line)
    assert result == {1, %{end_date: ~N[2017-04-21 00:00:00], start_date: ~N[2016-10-27 00:00:00]}}
  end
end