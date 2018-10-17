defmodule ValidationTest do
  use ExUnit.Case
  # doctest BankAccount

  test "can verify transactions" do
    data = %{
      account_index: "00",
      account_number: "1234567",
      account_title: "persönliches Konto",
      branch_number: "123",
      currency: "EUR",
      last_balance: "1.999,99",
      current_balance: "2.770,81",
      current_balance_date: "09.11.2014",
      start_date: "27.10.2014",
      end_date: "09.11.2014",
      filename: "Kontoumsaetze_persoenliches_Konto.csv",
      headers: %{
        beneficiary_client: "Begünstigter / Auftraggeber",
        bic: "BIC",
        booking_date: "Buchungstag",
        booking_value: "Wert",
        creditors_id: "Gläubiger ID",
        currency: "Währung",
        customer_reference: "Kundenreferenz",
        debit: "Soll",
        divergent_receiver: "Abweichender Empfänger",
        extra_amount: "Betrag",
        extra_fees: "Fremde Gebühren",
        have: "Haben",
        iban: "IBAN",
        mandate_reference: "Mandatsreferenz",
        number_of_checks: "Anzahl der Schecks",
        number_of_orders: "Anzahl der Aufträge",
        sales_type: "Umsatzart",
        usage: "Verwendungszweck"
      },
      transactions: [
        %{
          beneficiary_client: "Lorem ipsum",
          bic: "",
          booking_date: "27.10.2014",
          booking_value: "27.10.2014",
          creditors_id: "",
          currency: "EUR",
          customer_reference: "",
          debit: "",
          divergent_receiver: "",
          extra_amount: "",
          extra_fees: "",
          have: "1.000,00",
          iban: "DE01234567890123456789",
          mandate_reference: "",
          number_of_checks: "",
          number_of_orders: "",
          sales_type: "\"SEPA-Gutschrift von\"",
          usage: "Rechnung 123456"
        },
        %{
          beneficiary_client: "",
          bic: "",
          booking_date: "27.10.2014",
          booking_value: "28.10.2014",
          creditors_id: "",
          currency: "EUR",
          customer_reference: "",
          debit: "-99,99",
          divergent_receiver: "",
          extra_amount: "",
          extra_fees: "",
          have: "",
          iban: "",
          mandate_reference: "",
          number_of_checks: "",
          number_of_orders: "",
          sales_type: "",
          usage: "0123456789 MAX MUSTERMAN DEUTSCHE BANK KREDITKARTE MAX MUSTERMAN"
        },
        %{
          beneficiary_client: "",
          bic: "",
          booking_date: "31.10.2014",
          booking_value: "31.10.2014",
          creditors_id: "",
          currency: "EUR",
          customer_reference: "",
          debit: "-19,19",
          divergent_receiver: "",
          extra_amount: "",
          extra_fees: "",
          have: "",
          iban: "",
          mandate_reference: "",
          number_of_checks: "",
          number_of_orders: "",
          sales_type: "\"Kartenzahlung\"",
          usage: "LEBENSMITTEL"
        },
        %{
          beneficiary_client: "AMAZON EU S.A R.L., NIEDERLASSUNG DEUTSCHLAND",
          bic: "ABCDEFG",
          booking_date: "01.11.2014",
          booking_value: "01.11.2014",
          creditors_id: "DE01234567890123456789",
          currency: "EUR",
          customer_reference: "0123456789",
          debit: "-10,00",
          divergent_receiver: "",
          extra_amount: "",
          extra_fees: "",
          have: "",
          iban: "DE01234567890123456789",
          mandate_reference: "",
          number_of_checks: "",
          number_of_orders: "",
          sales_type: "\"SEPA-Lastschrift von\"",
          usage: "Amazon.de"
        },
        %{
          beneficiary_client: "",
          bic: "",
          booking_date: "09.11.2014",
          booking_value: "09.11.2014",
          creditors_id: "",
          currency: "EUR",
          customer_reference: "",
          debit: "-100,00",
          divergent_receiver: "",
          extra_amount: "",
          extra_fees: "",
          have: "",
          iban: "",
          mandate_reference: "",
          number_of_checks: "",
          number_of_orders: "",
          sales_type: "\"Auszahlung Geldautomat\"",
          usage: "Postbank//Berlin"
        }
      ]
    }

    assert :ok == Validation.verify_transactions(data)

  end

end