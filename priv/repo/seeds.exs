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
alias BudgetTrackingTool.Accounts.{User, Org, UserOrg}

today = Date.utc_today()

Repo.delete_all(User, skip_org_id: true)
Repo.delete_all(Budget, skip_org_id: true)
Repo.delete_all(Transaction, skip_org_id: true)
Repo.delete_all(Book, skip_org_id: true)
Repo.delete_all(Category, skip_org_id: true)

user =
  Repo.insert!(
    User.registration_changeset(%User{}, %{
      email: "de.caluwe.bart@gmail.com",
      password: "qwerqwer12341234"
    }),
    skip_org_id: true
  )

org =
  Repo.insert!(
    Org.changeset(%Org{}, %{
      name: "Drollemannen"
    }),
    skip_org_id: true
  )

Repo.insert!(UserOrg.changeset(%UserOrg{}, %{user_id: user.id, org_id: org.id}), skip_org_id: true)

housekeeping =
  Repo.insert!(
    %Book{
      name: "Housekeeping",
      starting_balance: Money.new(100),
      org: org
    },
    skip_org_id: true
  )

office =
  Repo.insert!(
    %Book{
      name: "Office",
      starting_balance: Money.new(100),
      org: org
    },
    skip_org_id: true
  )

groceries =
  Repo.insert!(
    %Category{
      label: "Groceries",
      is_income: false,
      overspent_behavior: :carry_over,
      org: org
    },
    skip_org_id: true
  )

rent =
  Repo.insert!(
    %Category{
      label: "Rent",
      is_income: false,
      overspent_behavior: :deduct,
      org: org
    },
    skip_org_id: true
  )

eating_out =
  Repo.insert!(
    %Category{
      label: "Eating out",
      is_income: false,
      overspent_behavior: :deduct,
      org: org
    },
    skip_org_id: true
  )

loon =
  Repo.insert!(
    %Category{
      label: "Loon",
      is_income: true,
      overspent_behavior: :deduct,
      org: org
    },
    skip_org_id: true
  )

Repo.insert!(
  %Budget{
    amount: Money.new(20000),
    date: today,
    category: eating_out,
    book: housekeeping,
    org: org
  },
  skip_org_id: true
)

transactions = [
  %Transaction{
    description: "Loon",
    amount: Money.new(170_000),
    date: today,
    category: loon,
    book: housekeeping,
    org: org
  },
  %Transaction{
    description: "Takumi",
    amount: Money.new(12200),
    date: today,
    category: eating_out,
    book: housekeeping,
    org: org
  },
  %Transaction{
    description: "Pingo Doce",
    amount: Money.new(5000),
    date: today,
    category: groceries,
    book: housekeeping,
    org: org
  }
]

transactions
|> Enum.each(fn t -> Repo.insert!(t, skip_org_id: true) end)
