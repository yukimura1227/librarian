# for order
class Order < ApplicationRecord
  belongs_to :user
  has_one :book
  enum state: { order_purchase_waiting: 0, order_purchased: 10 }

  attr_reader :parsed_title, :parsed_image_path, :parsed_html

  after_create :notify_slack

  validates :title, presence: true
  validates :url, presence: true

  def purchase
    create_book(
      title: title
    )
    order_purchased!
  end

  def extract_amazon_product_info!(target_url = nil)
    target_url = target_url.presence || url
    agent = Mechanize.new
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

  private

  def notify_slack
    return if Rails.application.config.slack_webhook_url.blank?
    notifier = Slack::Notifier.new(Rails.application.config.slack_webhook_url)
    message = <<~"MESSAGE"
      @#{notify_to} 「#{title}」の注文依頼がありました。
      #{url}
    MESSAGE
    notifier.ping(message, parse: "full")
  end

  def notify_to
    Rails.application.config.slack_notify_to || 'here'
  end
end
