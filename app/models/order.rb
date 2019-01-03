# for order
class Order < ApplicationRecord
  belongs_to :user
  has_one :book
  enum state: { order_purchase_waiting: 0, order_purchased: 10 }

  def purchase
    create_book(
      title: title
    )
    order_purchased!
  end
end
