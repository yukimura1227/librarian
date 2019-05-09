# model for books
class Book < ApplicationRecord
  RENTAL_LIMIT_DAYS = 30
  belongs_to :order
  belongs_to :user, optional: true
  has_one :last_rental_operation, -> { order(id: :desc) }, class_name: 'Operation::Rental'

  scope :rentaled, -> {
    where.not(user_id: nil)
  }

  def self.prompt_for_return
    rentaled.select(&:rented_for_a_long_time?).each(&:notify_slack_prompt_for_return)
  end

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

  def notify_slack_prompt_for_return
    message = <<~"MESSAGE"
      To: @#{user&.slack_name} 「#{title}」は、まだ借りていますか？返却済みの場合は、「返す」処理をしてください。まだ借りている場合は、「延長する」処理をしてください。
      #{Rails.application.config.application_domain}/#{Rails.application.routes.url_helpers.books_path(q: { id_eq: id })}
    MESSAGE
    notify_slack message
  end

  def title_duplicated?
    return false if valid?(:check_title_unique)
    return false unless errors.include?(:title)

    errors.details[:title].map { |v| v[:error] }.include?(:taken)
  end

  private

  def notify_slack(message)
    return if Rails.application.config.slack_webhook_url.blank?

    notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
    notifier.ping(message, parse: 'full')
  end

end
