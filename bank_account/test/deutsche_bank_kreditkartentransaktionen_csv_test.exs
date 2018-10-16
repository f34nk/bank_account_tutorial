defmodule DeutscheBankKreditkartentransaktionenCsvTest do
  use ExUnit.Case
  # doctest BankAccount

  test "can parse line 0 with of account_title persönliches Konto" do
    line = "Kreditkartentransaktionen;;Kundennummer: 123 1234567"
    result = DeutscheBankKreditkartentransaktionenCsv.parse_line(0, line)
    assert result == {0, %{account_number: "1234567", branch_number: "123", account_title: "Kreditkartentransaktionen"}}
  end

  test "can parse line 1 with card_name and card_number" do
    line = "MasterCard 1234 5678 9012 3456 MAX MUSTERMAN"
    result = DeutscheBankKreditkartentransaktionenCsv.parse_line(1, line)
    assert result == {1, %{card_holder: "MAX MUSTERMAN", card_name: "MasterCard", card_number: "1234567890123456"}}
  end

  test "can parse line 2 with current_date" do
    line = "Offene / aktuelle Umsätze per: 14.03.2014"
    result = DeutscheBankKreditkartentransaktionenCsv.parse_line(2, line)
    assert result == {2, %{current_date: ~N[2014-03-14 00:00:00]}}
  end

end