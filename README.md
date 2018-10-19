**Work in Progress**

# Bank Account Tutorial

As a personal exercise I implemented an Elixir application that gives me some insights about the transactions on my bank account. At the end of this demo, there should be a nice line graph displaying all transactions imported from multiple files.

Please checkout the git branches to see which parts are already implemented.

## Part 1

Branch [part_1](https://github.com/f34nk/bank_account_tutorial/tree/part_1)

This part implements the application `bank_account` to handle the account data.
The first feature is `import/2` to import files with account transactions.
Right now, only CSV files from "Deutsche Bank" are supported.

See [bank_account_test](https://github.com/f34nk/bank_account_tutorial/blob/part_1/bank_account/test/bank_account_test.exs)

## Part 2

Branch [part_2](https://github.com/f34nk/bank_account_tutorial/tree/part_2)

Added kipcole9's [Money](https://github.com/kipcole9/money) package to perform basic money operations.

See [money_test](https://github.com/f34nk/bank_account_tutorial/blob/part_2/bank_account/test/money_test.exs)


Created phoenix application `bank_account_web` (without Ecto) and added `bank_account` as a dependency.

Render data in a line graph using [Chartjs](http://www.chartjs.org).
Render data in a table using boottsrap 4 [Datatable](https://datatables.net).

In progress...

## Roadmap

- [x] Part 1: Import CSV files from a "Deutsche Bank" account
- [ ] Part 2:
	- [ ] Calculate basic operations
	- [x] Render account as line graph
	- [x] Render account as table