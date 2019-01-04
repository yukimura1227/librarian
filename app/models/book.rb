# model for books
class Book < ApplicationRecord
  belongs_to :order
  belongs_to :user

  def rentaled?
    user.present?
  end

  def rentaled_by?(user)
    user.present? && self.user == user
  end
end
