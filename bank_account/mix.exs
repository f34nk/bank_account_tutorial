defmodule BankAccount.MixProject do
  use Mix.Project

  def project do
    [
      app: :bank_account,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: Mix.compilers ++ [:cldr]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:codepagex, "~> 0.1.4"},
      {:csv, "~> 1.4.2"},
      {:timex, "~> 3.1"},

      # https://github.com/kipcole9/money
      {:ex_money, "~> 2.10"},
      {:jason, "~> 1.0"}
    ]
  end
end
