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

## Roadmap

- [x] Part 1: Import CSV files from a "Deutsche Bank" account
- [ ] Calculate basic operations
- [ ] Render account