# for order
class Order < ApplicationRecord
  belongs_to :user
  has_one :book
  enum state: { order_purchase_waiting: 0, order_purchased: 10 }

  attr_reader :parsed_title, :parsed_image_path, :parsed_html

  after_create :notify_slack_ordered

  validates :title, presence: true
  validates :url, presence: true

  scope :wait_for_purchase_a_long_time, ->(reference_date: 7.days.ago.beginning_of_day) {
    order_purchase_waiting.where('order_time < ?', reference_date)
  }

  def self.urge_to_purchased
    wait_for_purchase_a_long_time.each(&:notify_slack_urge_to_purchased)
  end

  def purchase
    create_book(
      title: title
    )
    order_purchased!
  end

  def extract_amazon_product_info!(target_url = nil)
    target_url = target_url.presence || url
    agent = Mechanize.new
    agent.user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36'
    page = agent.get(target_url)
    elements = page.search('#dp-container')
    @parsed_title = elements.search('#productTitle').inner_text
    img_wrap = elements.search('#img-canvas')
    @parsed_image_path = img_wrap.search('img').first[:src]
    @parsed_html = elements.to_html
    self.origin_html = @parsed_html
    self.image_path = @parsed_image_path
    elements
  end

  protected

  def notify_slack_urge_to_purchased
    message = <<~"MESSAGE"
      To: @#{user.slack_name} 「#{title}」の購入は完了していますか？完了している場合は、購入済みにしてください。
      #{url}
    MESSAGE
    notify_slack message
  end

  private

  def notify_slack_ordered
    message = <<~"MESSAGE"
      To: @#{notify_to} @#{user.slack_name}から「#{title}」の注文依頼がありました。
      #{url}
    MESSAGE

    notify_slack message
  end

  def notify_slack(message)
    return if Rails.application.config.slack_webhook_url.blank?

    notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
    notifier.ping(message, parse: 'full')
  end

  def notify_to
    Rails.application.config.slack_notify_to || 'here'
  end
end
