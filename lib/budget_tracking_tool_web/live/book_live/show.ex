defmodule BudgetTrackingToolWeb.BookLive.Show do
  use BudgetTrackingToolWeb, :live_view
  use Timex

  alias BudgetTrackingTool.{Budgets, Books, Categories, Transactions}
  alias BudgetTrackingTool.Budgets.Budget
  alias BudgetTrackingTool.Transactions.Transaction
  alias BudgetTrackingTool.Books.Book
  alias BudgetTrackingTool.Categories.Category

  @default_params %{"date" => Date.utc_today() |> Date.to_string()}

  @impl true
  def mount(_params, session, socket) do
    put_org_id_from_session(session)

    {:ok,
     socket
     |> PhoenixLiveSession.maybe_subscribe(session)
     |> put_session_assigns(session)
     |> assign(:show_header, false)}
  end

  @impl true
  def handle_params(params, _session, socket) do
    id = socket.assigns.selected_book_id
    %{"date" => date} = Map.merge(@default_params, params)

    date = Date.from_iso8601!(date)
    book = Books.get_book!(id)
    transactions = list_transactions(date, id)
    balance = calculate_balance_for_month(date, id)

    {:noreply,
     socket
     |> assign(:page_title, book.name)
     |> assign(:book, book)
     |> assign(:books, Books.list_books())
     |> assign(:selected_month, date)
     |> assign(:categories, list_categories())
     |> assign(:expense_categories, list_expense_categories())
     |> assign(:balance, balance)
     |> assign(:budgets, list_budgets(date, id))
     |> assign(:transactions, transactions)
     |> put_default_transaction_assigns(date, id)}
  end

  @impl true
  def handle_event("select-book", %{"book_id" => book_id}, socket) do
    PhoenixLiveSession.put_session(socket, "selected_book_id", book_id)

    {:noreply,
     push_patch(
       socket
       |> assign(:selected_book_id, book_id),
       to: Routes.book_show_path(socket, :show, date: format_date_param(socket.assigns.selected_month))
     )}
  end

  @impl true
  def handle_info({:live_session_updated, session}, socket) do
    {:noreply,
     push_patch(
       socket
       |> put_session_assigns(session),
       to: Routes.book_show_path(socket, :show, date: format_date_param(socket.assigns.selected_month))
     )}
  end

  def calculate_balance_for_month(date, book_id) do
    Transactions.calculate_balance_for_month(date.month(), date.year(), book_id)
  end

  def previous_month(date) do
    date
    |> Timex.shift(months: -1)
    |> Timex.set(day: 1)
    |> format_date_param()
  end

  def next_month(date) do
    date
    |> Timex.shift(months: 1)
    |> Timex.set(day: 1)
    |> format_date_param()
  end

  def current_month do
    Date.utc_today() |> format_date_param()
  end

  def format_date_param(date) do
    date |> Timex.format!("{YYYY}-{0M}-{0D}")
  end

  def format_date(date) do
    month_name = date.month() |> Timex.month_name()
    "#{month_name} #{date.year()}"
  end

  def to_be_budgetted(date, book_id) do
    to_be_budgetted =
      Transactions.calculate_income_for_month(
        date.month(),
        date.year(),
        book_id
      )

    if to_be_budgetted > 0 do
      to_be_budgetted
    else
      0
    end
  end

  def total_budgetted(budgets) do
    budgets
    |> Enum.map(& &1.amount.amount)
    |> Enum.reduce(0, fn t, acc -> acc + t end)
  end

  def total_spent(transactions) do
    transactions
    |> Enum.filter(fn t -> t.category.is_income == false end)
    |> total_amount()
  end

  def total_available(transactions, budgets) do
    total_budgetted(budgets) - total_spent(transactions)
  end

  defp transactions_for_category(category, transactions) do
    transactions
    |> Enum.filter(fn t -> t.category_id == category.id end)
  end

  defp budget_for_category(category_id, budgets, book_id, date) do
    budgets
    |> Enum.find(
      %Budget{
        date: date,
        book_id: book_id,
        category_id: category_id,
        amount: Money.new(0),
        org_id: BudgetTrackingTool.Repo.get_org_id()
      },
      fn b -> b.category_id == category_id end
    )
  end

  defp total_amount([]), do: 0

  defp total_amount(transactions) do
    transactions
    |> Enum.map(& &1.amount.amount)
    |> Enum.reduce(0, fn t, acc -> acc + t end)
  end

  defp list_categories do
    Categories.list_categories()
  end

  defp list_expense_categories do
    Categories.list_expense_categories()
  end

  defp list_transactions(date, book_id) do
    Transactions.list_transactions(date.month(), date.year(), book_id)
  end

  defp list_budgets(date, book_id) do
    Budgets.list_budgets(date.month(), date.year(), book_id)
  end

  defp put_session_assigns(socket, session) do
    case Books.get_book() do
      %Book{id: id} ->
        socket
        |> assign(:selected_book_id, Map.get(session, "selected_book_id", id))

      nil ->
        socket
        |> put_flash(:info, "You need to create at least one book before you can start.")
        |> push_redirect(to: Routes.book_index_path(socket, :new))
    end
  end

  defp put_default_transaction_assigns(socket, date, id) do
    case Enum.at(list_categories(), 0) do
      %Category{} = category ->
        socket
        |> assign(:transaction, %Transaction{
          amount: nil,
          date: date,
          book_id: id,
          org_id: BudgetTrackingTool.Repo.get_org_id(),
          category_id: category.id,
          category: category
        })

      nil ->
        socket
        |> put_flash(:info, "You need to create at least one category before you can start.")
        |> push_redirect(to: Routes.category_index_path(socket, :new))
    end
  end

  def get_balance_text_color(balance) do
    if balance < 0 do
      "text-red-500"
    else
      "text-gray-500"
    end
  end
end
