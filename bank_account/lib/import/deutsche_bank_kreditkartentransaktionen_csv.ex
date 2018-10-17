defmodule DeutscheBankKreditkartentransaktionenCsv do

  def parse_line(0, "Kreditkartentransaktionen" <> rest = line) do
    case Regex.run(~r/([A-Za-zm ö]*);{2}Kundennummer: ([0-9]{3}) ([0-9]{7})/, line) do
      [_, account_title, branch_number, account_number] ->
        {0, %{account_title: account_title, branch_number: branch_number, account_number: account_number}}
      _ -> raise "Failed to parse line 0"
    end
  end

  def parse_line(0, _) do
    raise "Failed to parse line 0"
  end

  def parse_line(1, line) do
    case Regex.run(~r/([A-Za-zm ÄÖÜäöü]*) ([0-9]{4}) ([0-9]{4}) ([0-9]{4}) ([0-9]{4}) ([A-Za-zm ÄÖÜäöü]*)/, line) do
      [_, card_name, card_number1, card_number2, card_number3, card_number4, card_holder] ->
        card_number = card_number1 <> card_number2 <> card_number3 <> card_number4
        {1, %{card_name: card_name, card_number: card_number, card_holder: card_holder}}
      _ -> raise "Failed to parse line 1"
    end
  end

  def parse_line(2, "Offene / aktuelle Umsätze per: " <> rest = line) do
    case Regex.run(~r/Offene \/ aktuelle Umsätze per: ([0-9]{2}.[0-9]{2}.[0-9]{4})/, line) do
      [_, current_date] ->
        {2, %{current_date: current_date}}
      _ -> raise "Failed to parse line 2"
    end
  end

  def parse_line(3, "Abrechnungsdatum: " <> rest = line) do
    case Regex.run(~r/Abrechnungsdatum: ([0-9]{2}.[0-9]{2}.[0-9]{4})/, line) do
      [_, last_date] ->
        {3, %{last_date: last_date}}
      _ -> raise "Failed to parse line 2"
    end
  end

  def parse_line(4, "Belegdatum;Eingangstag;Verwendungszweck;Fremdwährung;Betrag;Kurs;Betrag;Währung" = headers) do
    {4, %{headers: %{document_date: "Belegdatum", date_of_receipt: "Eingangstag", usage: "Verwendungszweck", extra_fees: "Fremdwährung", extra_amount: "Betrag", price: "Kurs", price_amount: "Betrag", currency: "Währung"}}}
  end

  def parse_line(4, _) do
    raise "Failed to parse column headers!"
  end

  # Online-Saldo:;;;;;;-41,80;EUR
  def parse_line(index, "Online-Saldo" <> rest) when index > 4 do
    [_, _, _, _, _, _, current_balance, currency] = String.split(rest, ";")
    {index, %{current_balance: current_balance, currency: currency}}
  end

  # 23.02.2014;26.02.2014;Lorem ipsum  ONLINESHOP BERLIN;;;;- 1,70;EUR
  def parse_line(index, line) when index > 4 do
    {index, %{row: parse_row(String.split(line, ";"))}}
  end

  def parse_row([document_date, date_of_receipt, usage, extra_fees, extra_amount, price, price_amount, currency] = row) do
    %{document_date: document_date, date_of_receipt: date_of_receipt, usage: usage, extra_fees: extra_fees, extra_amount: extra_amount, price: price, price_amount: price_amount, currency: currency}
  end

  def parse_row(_) do
    raise "Row has insufficient number of entries!"
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