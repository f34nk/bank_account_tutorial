defmodule BankAccountWeb.Web.PageController do
  use BankAccountWeb.Web, :controller

  def index(conn, _params) do

    filepath = "../bank_account/test/fixtures/Kontoumsaetze_persoenliches_Konto.csv"
    # filepath = "../bank_account/test/fixtures/Kontoumsaetze_SparCard.csv"
    # filepath = "../bank_account/test/fixtures/Kreditkartentransaktionen123456789_20140312.csv"

    {:ok, data} = BankAccount.import("Deutsche Bank", filepath)
    data = BankAccount.Utils.calculate_total_balance(data)
    render conn, "index.html", data: data
  end
end
