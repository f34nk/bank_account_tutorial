defmodule Validation do

  def sum_up_transactions([%{currency: "EUR" = currency, debit: "", have: have}|transactions], return) do
    result = Money.add!(return, Money.new(have, currency, locale: "de"))
    sum_up_transactions(transactions, result)
  end

  def sum_up_transactions([%{currency: "EUR" = currency, debit: debit, have: ""}|transactions], return) do
    result = Money.add!(return, Money.new(debit, currency, locale: "de"))
    sum_up_transactions(transactions, result)
  end

  def sum_up_transactions([], return), do: return

  def verify_transactions(%{currency: "EUR" = currency,  last_balance: last_balance, current_balance: current_balance, current_balance_date: current_balance_date, start_date: start_date, end_date: end_date, transactions: transactions} = data) do

    sum = sum_up_transactions(transactions, Money.new(0, currency))
    result = Money.add!(Money.new(last_balance, currency, locale: "de"), sum)
    |> Money.to_string!([currency: :EUR, locale: "de", format: "#,##0.##"])

    cond do
      result == current_balance -> :ok
      true -> {:error, "The sum of all transactions does not match the current balance!"}
    end

  end

end