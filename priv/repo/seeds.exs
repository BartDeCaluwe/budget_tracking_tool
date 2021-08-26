# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BudgetTrackingTool.Repo.insert!(%BudgetTrackingTool.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias BudgetTrackingTool.Repo
alias BudgetTrackingTool.Transactions.Transaction
alias BudgetTrackingTool.Categories.Category
alias BudgetTrackingTool.Books
alias BudgetTrackingTool.Books.Book
alias BudgetTrackingTool.Budgets.Budget
alias BudgetTrackingTool.Accounts.User
alias BudgetTrackingTool.Accounts.Org

today = Date.utc_today()

Repo.delete_all(User)
Repo.delete_all(Org)
Repo.delete_all(Budget)
Repo.delete_all(Transaction)
Repo.delete_all(Book)
Repo.delete_all(Category)

housekeeping =
  Repo.insert!(%Book{
    name: "Housekeeping"
  })

office =
  Repo.insert!(%Book{
    name: "Office"
  })

groceries =
  Repo.insert!(%Category{
    label: "Groceries",
    is_income: false,
    overspent_behavior: :carry_over
  })

rent =
  Repo.insert!(%Category{
    label: "Rent",
    is_income: false,
    overspent_behavior: :deduct
  })

eating_out =
  Repo.insert!(%Category{
    label: "Eating out",
    is_income: false,
    overspent_behavior: :deduct
  })

loon =
  Repo.insert!(%Category{
    label: "Loon",
    is_income: true,
    overspent_behavior: :deduct
  })

Repo.insert!(%Budget{
  amount: 200,
  date: today,
  category: eating_out,
  book: housekeeping
})

transactions = [
  %Transaction{
    description: "Loon",
    amount: 1700,
    date: today,
    category: loon,
    book: housekeeping
  },
  %Transaction{
    description: "Takumi",
    amount: 122,
    date: today,
    category: eating_out,
    book: housekeeping
  },
  %Transaction{
    description: "Pingo Doce",
    amount: 50,
    date: today,
    category: groceries,
    book: housekeeping
  }
]

transactions
|> Enum.each(fn t -> Repo.insert!(t) end)
