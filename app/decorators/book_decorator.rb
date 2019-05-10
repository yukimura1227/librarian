class BookDecorator < Draper::Decorator
  delegate_all

  def last_rental_at
    "レンタル日時：#{h.l(book.last_rental_operation.created_at, format: :short)}"
  end
end
