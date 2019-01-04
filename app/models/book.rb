# model for books
class Book < ApplicationRecord
  belongs_to :order
  belongs_to :user
end
