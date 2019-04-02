# model for books
class Book < ApplicationRecord
  belongs_to :order
  belongs_to :user, optional: true
  has_one :last_rental_operation, -> { order(id: :desc) }, class_name: 'Operation::Rental'


  def rentaled?
    user.present?
  end

  def rentaled_by?(user)
    user.present? && self.user == user
  end
end
