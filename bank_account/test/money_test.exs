defmodule MoneyTest do
  use ExUnit.Case
  # doctest BankAccount

  test "create Money from string" do
    result = Money.new("1000.99", :EUR)
    assert result.currency == :EUR
    assert result.amount == Decimal.new(1000.99)

    result = Money.from_float!(:EUR, 1000.99)
    assert result.currency == :EUR
    assert result.amount == Decimal.new(1000.99)

    result = Money.new("1.000,99", :EUR)
    assert {:error, {Money.InvalidAmountError, "Amount cannot be converted to a number: \"1.000,99\""}} = result

    result = Money.new("1.000,99", :EUR, locale: "de")
    assert result.currency == :EUR
    assert result.amount == Decimal.new(1000.99)
  end

  test "convert Money to string" do
    # Be sure to add "de" to the supported locales in the configuration.
    # config :ex_cldr, locales: ["de"]

    result = Money.new("1000000.99", :EUR)
    |> Money.to_string!([currency: :EUR, locale: "de"])
    assert "1.000.000,99 €" = result

    result = Money.new("1000.99", :EUR)
    |> Money.to_string!([currency: :EUR, locale: "de"])
    assert "1.000,99 €" = result

    result = Money.new("1000000.99", :EUR)
    |> Money.to_string!([currency: :EUR, locale: "de", format: "#,##0.##"])
    assert "1.000.000,99" = result

    result = Money.new("1.000,99", :EUR, locale: "de")
    |> Money.to_string!([format: "###0.##"])
    assert "1000.99" = result

  end

end