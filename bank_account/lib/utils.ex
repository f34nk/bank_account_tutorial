defmodule BankAccount.Utils do

  def to_printable_amount(amount, :EUR) do
    to_printable_amount(amount, :EUR, "de")
  end

  def to_printable_amount(amount, "EUR") do
    to_printable_amount(amount, :EUR, "de")
  end

  def to_printable_amount("", currency, locale) do
    "NaN"
  end

  def to_printable_amount(amount, currency, locale) do
    result = Money.new(amount, currency, locale: locale)
    |> Money.to_string!([format: "###0.##"])
  end



  def do_calculate_total_balance([%{currency: "EUR" = currency, debit: "", have: have} = transaction | transactions], last_balance, return) do

    last_balance = Money.add!(last_balance, Money.new(have, currency, locale: "de"))
    result = Money.to_string!(last_balance, [currency: currency, locale: "de", format: "#,##0.##"])

    do_calculate_total_balance(transactions, last_balance, return ++ [Map.put(transaction, :total_balance, result)])
  end

  def do_calculate_total_balance([%{currency: "EUR" = currency, debit: debit, have: ""} = transaction | transactions], last_balance,  return) do

    last_balance = Money.add!(last_balance, Money.new(debit, currency, locale: "de"))
    result = Money.to_string!(last_balance, [currency: currency, locale: "de", format: "#,##0.##"])

    do_calculate_total_balance(transactions, last_balance, return ++ [Map.put(transaction, :total_balance, result)])
  end

  def do_calculate_total_balance([], _, return), do: return

  def calculate_total_balance(%{currency: "EUR" = currency,  last_balance: last_balance, current_balance: current_balance, current_balance_date: current_balance_date, start_date: start_date, end_date: end_date, headers: headers, transactions: transactions} = data) do

    transactions = do_calculate_total_balance(transactions, Money.new(last_balance, currency, locale: "de"), [])

    headers = Map.put(headers, :total_balance, "Ist")

    data = data
    |> Map.put(:headers, headers)
    |> Map.put(:transactions, transactions)

  end

end