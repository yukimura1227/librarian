# model for books
class Book < ApplicationRecord
  RENTAL_LIMIT_DAYS = 30
  belongs_to :order
  belongs_to :user, optional: true
  has_one :last_rental_operation, -> { order(id: :desc) }, class_name: 'Operation::Rental'

  scope :rentaled, -> {
    where.not(user_id: nil)
  }

  def rented_for_a_long_time?
    return false unless rentaled?

    last_rental_operation.created_at <= RENTAL_LIMIT_DAYS.days.ago
  end

  def rentaled?
    user.present?
  end

  def rentaled_by?(user)
    user.present? && self.user == user
  end
end
