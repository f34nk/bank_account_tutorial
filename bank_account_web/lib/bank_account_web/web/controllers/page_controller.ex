defmodule BankAccountWeb.Web.PageController do
  use BankAccountWeb.Web, :controller

  def index(conn, _params) do

    filepath = "../bank_account/test/fixtures/Kontoumsaetze_persoenliches_Konto.csv"
    {:ok, data} = BankAccount.import("Deutsche Bank", filepath)

    render conn, "index.html", data: data
  end
end
