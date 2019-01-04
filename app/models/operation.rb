# for operations
class Operation < ApplicationRecord
  belongs_to :user
  belongs_to :book
end
