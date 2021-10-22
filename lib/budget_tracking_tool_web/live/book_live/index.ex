defmodule BudgetTrackingToolWeb.BookLive.Index do
  use BudgetTrackingToolWeb, :live_view

  alias BudgetTrackingTool.Books
  alias BudgetTrackingTool.Books.Book
  alias BudgetTrackingTool.Transactions

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> PhoenixLiveSession.maybe_subscribe(session)
     |> assign(:books, list_books())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Book")
    |> assign(:book, Books.get_book!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Book")
    |> assign(:book, %Book{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Books")
    |> assign(:book, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    book = Books.get_book!(id)
    {:ok, _} = Books.delete_book(book)

    {:noreply, assign(socket, :books, list_books())}
  end

  def handle_event("select-book", %{"book_id" => book_id}, socket) do
    today = Date.utc_today()
    PhoenixLiveSession.put_session(socket, "selected_book_id", book_id)

    {:noreply,
     redirect(
       socket
       |> assign(:selected_book_id, book_id),
       to: Routes.book_show_path(socket, :show, date: format_date_param(today))
     )}
  end

  defp format_date_param(date) do
    date |> Timex.format!("{YYYY}-{0M}-{0D}")
  end

  defp list_books do
    Books.list_books()
  end

  defp available_balance_for_current_month(book_id) do
    today = Date.utc_today()
    Transactions.calculate_balance_for_month(today.month(), today.year(), book_id)
  end

  defp put_session_assigns(socket, session) do
    socket
    |> assign(:selected_book_id, Map.get(session, "selected_book_id", Books.get_book!().id))
  end
end
