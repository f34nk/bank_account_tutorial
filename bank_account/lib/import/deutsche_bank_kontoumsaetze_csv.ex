defmodule DeutscheBankKontoumsaetzeCsv do

  def parse_line(0, "Umsätze " <> rest) do
    case Regex.run(~r/([A-Za-zm ö]*) \(([0-9]{2})\);{3}Kundennummer: ([0-9]{3}) ([0-9]{7})/, rest) do
      [_, account_title, account_index, branch_number, account_number] ->
        {0, %{account_title: account_title, account_index: account_index, branch_number: branch_number, account_number: account_number}}
      _ -> raise "Failed to parse line 0"
    end
  end

  def parse_line(0, _) do
    raise "Failed to parse line 0"
  end

  # 27.10.2014 - 21.04.2015
  def parse_line(1, time_period) do
    [_, start_date, end_date] = Regex.run(~r/([0-9.]*) - ([0-9.]*)/, time_period)
    {1, %{start_date: start_date, end_date: end_date}}
  end

  # Letzter Kontostand;;;;1.999,99;EUR
  def parse_line(2, "Letzter Kontostand" <> rest) do
    [_, _, _, _, last_balance, currency] = String.split(rest, ";")
    {2, %{last_balance: last_balance, currency: currency}}
  end

  def parse_line(2, _) do
    raise "Failed to parse line 2"
  end

  def parse_line(3, "Vorgemerkte und noch nicht gebuchte Umsätze sind nicht Bestandteil dieser Übersicht.") do
    {3, nil}
  end

  def parse_line(3, _) do
    raise "Failed to parse line 3"
  end

  # Buchungstag;Wert;Umsatzart;Begünstigter / Auftraggeber;Verwendungszweck;IBAN;BIC;Kundenreferenz;Mandatsreferenz ;Gläubiger ID;Fremde Gebühren;Betrag;Abweichender Empfänger;Anzahl der Aufträge;Anzahl der Schecks;Soll;Haben;Währung
  def parse_line(4, "Buchungstag;Wert;Umsatzart;Begünstigter / Auftraggeber;Verwendungszweck;IBAN;BIC;Kundenreferenz;Mandatsreferenz ;Gläubiger ID;Fremde Gebühren;Betrag;Abweichender Empfänger;Anzahl der Aufträge;Anzahl der Schecks;Soll;Haben;Währung" = headers) do
    {4, %{headers: %{booking_date: "Buchungstag", booking_value: "Wert", sales_type: "Umsatzart", beneficiary_client: "Begünstigter / Auftraggeber", usage: "Verwendungszweck", iban: "IBAN", bic: "BIC", customer_reference: "Kundenreferenz", mandate_reference: "Mandatsreferenz", creditors_id: "Gläubiger ID", extra_fees: "Fremde Gebühren", extra_amount: "Betrag", divergent_receiver: "Abweichender Empfänger", number_of_orders: "Anzahl der Aufträge", number_of_checks: "Anzahl der Schecks", debit: "Soll", have: "Haben", currency: "Währung"}}}
  end

  def parse_line(4, _) do
    raise "Failed to parse column headers!"
  end

  # Kontostand;21.04.2015;;;2.770,81;EUR
  def parse_line(index, "Kontostand" <> rest) when index > 4 do
    [_, current_balance_date, _, _, current_balance, currency] = String.split(rest, ";")
    {index, %{current_balance_date: current_balance_date, current_balance: current_balance, currency: currency}}
  end

  # Buchungstag;Wert;Umsatzart;Begünstigter / Auftraggeber;Verwendungszweck;IBAN;BIC;Kundenreferenz;Mandatsreferenz ;Gläubiger ID;Fremde Gebühren;Betrag;Abweichender Empfänger;Anzahl der Aufträge;Anzahl der Schecks;Soll;Haben;Währung
  def parse_row([booking_date, booking_value, sales_type, beneficiary_client, usage, iban, bic, customer_reference, mandate_reference, creditors_id, extra_fees, extra_amount, divergent_receiver, number_of_orders, number_of_checks, debit, have, currency] = row) do
    %{booking_date: booking_date, booking_value: booking_value, sales_type: sales_type, beneficiary_client: beneficiary_client, usage: usage, iban: iban, bic: bic, customer_reference: customer_reference, mandate_reference: mandate_reference, creditors_id: creditors_id, extra_fees: extra_fees, extra_amount: extra_amount, divergent_receiver: divergent_receiver, number_of_orders: number_of_orders, number_of_checks: number_of_checks, debit: debit, have: have, currency: currency}
  end

  def parse_row(_) do
    raise "Row has insufficient number of entries!"
  end

  # 31.10.2014;31.10.2014;"Kartenzahlung";;LEBENSMITTEL;;;;;;;;;;;-19,19;;EUR
  def parse_line(index, line) when index > 4 do
    {index, %{row: parse_row(String.split(line, ";"))}}
  end

  def parse({index, line}) do
    {:ok, string} = Codepagex.to_string(line, :iso_8859_1)
    case parse_line(index, string) do
      {_, nil} -> nil
      valid -> valid
    end
  end

  def process([{index, %{row: row}} | entries], %{rows: rows} = result) do
    result = Map.put(result, :rows, rows ++ [row])
    process(entries, result)
  end

  def process([{index, %{row: row}} | entries], result) do
    result = Map.put(result, :rows, [row])
    process(entries, result)
  end

  def process([{index, map} | entries], result) do
    process(entries, Map.merge(result, map))
  end

  def process([], result) do
    result
  end

  def import(filepath) do
    filename = Path.basename(filepath)

    stream = filepath
    |> File.stream!
    |> Stream.map(&String.strip/1)
    |> Stream.with_index
    |> Stream.map(fn {line, i} -> {i, line} end)

    parsed = Enum.reduce(stream, [], fn(line, lines) ->
      [parse(line)|lines]
    end)
    |> Enum.reject(& &1 == nil)
    |> Enum.sort(fn({x, _}, {y, _}) -> x < y end)
    |> process(%{filename: filename})

    {:ok, parsed}
  end
end