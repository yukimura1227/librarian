class Order < ApplicationRecord
  enum state: { order_purchase_waiting: 0, order_purchased: 10 }
end
