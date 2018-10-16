defmodule MoneyTest do
  use ExUnit.Case
  # doctest BankAccount

  test "parse float from string" do
    # we don't want to use float represenation
    # see:
    # https://github.com/kipcole9/money#float-amounts-cannot-be-provided-to-moneynew2

    result = Float.parse("1.000,99")
    assert {1.0, ",99"} = result

    result = Float.parse("1000.99")
    assert {1000.99, ""} = result
  end

  test "parse amount from string" do
    result = Money.new("1000.99", :EUR)
    assert result.currency == :EUR
    assert result.amount == Decimal.new(1000.99)

    result = Money.from_float!(:EUR, 1000.99)
    assert result.currency == :EUR
    assert result.amount == Decimal.new(1000.99)

    # german formatting does not work yet
    # see:
    # https://github.com/kipcole9/money/issues/83

    result = Money.new("1.000,99", :EUR)
    assert {:error, {Money.InvalidAmountError, "Amount cannot be converted to a number: \"1.000,99\""}} = result

  end

  test "can match amount with german formatting" do
    pattern = ~r/(\d{1,3}[^,]*),?(\d{1,2})?/

    string = "1.000.000,99"
    assert Regex.run(pattern, string) == ["1.000.000,99", "1.000.000", "99"]

    string = "100.000,99"
    assert Regex.run(pattern, string) == ["100.000,99", "100.000", "99"]

    string = "1.000,99"
    assert Regex.run(pattern, string) == ["1.000,99", "1.000", "99"]

    string = "1.000"
    assert Regex.run(pattern, string) == ["1.000", "1.000"]

    string = "1,99"
    assert Regex.run(pattern, string) == ["1,99", "1", "99"]

    string = "1"
    assert Regex.run(pattern, string) == ["1", "1"]
  end

  test "format string list to Money" do
    list = ["1.000.000,99", "1.000.000", "99"]

    result = case list do
      [_, integer, decimal] ->
        integer = String.replace(integer, ".", "")
        integer <> "." <> decimal
      [_, integer] ->
        integer = String.replace(integer, ".", "")
        integer <> "." <> "00"
      other -> raise "Something went wrong"
    end
    |> Money.new(:EUR)

    assert result.currency == :EUR
    assert result.amount == Decimal.new(1000000.99)
  end

  test "can convert Money to string in german format" do
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
  end

end