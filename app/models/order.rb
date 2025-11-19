# frozen_string_literal: true

require 'cgi'
require 'json'
require 'net/http'

# for order
class Order < ApplicationRecord
  include Utility::Slack
  belongs_to :user
  has_one :book
  enum state: { order_purchase_waiting: 0, order_purchased: 10 }

  attr_reader :parsed_title, :parsed_image_path, :parsed_html

  after_create :notify_slack_ordered

  validates :title, presence: true
  validates :title, uniqueness: true, on: :check_title_unique

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

  def extract_amazon_product_info!(isbn = nil)
    isbn = sanitized_isbn(isbn)
    raise OpenbdError, 'ISBNを入力してください。' if isbn.blank?

    response = fetch_openbd(isbn)
    raise OpenbdError, 'openBDから情報を取得できませんでした。' if response.blank?

    summary = response['summary'] || {}

    @parsed_title = summary['title']
    @parsed_image_path = summary['cover']
    @parsed_html = nil
    self.origin_html = @parsed_html
    self.image_path = @parsed_image_path

    response
  end

  def notify_slack_urge_to_purchased
    message = <<~"MESSAGE"
      To: #{user&.slack_name} 「#{title}」の購入は完了していますか？完了している場合は、購入済みにしてください。
      #{Rails.application.config.application_domain}/#{Rails.application.routes.url_helpers.orders_path(q: { state_eq: 0 })}
    MESSAGE
    notify_slack message
  end

  def title_duplicated?
    return false if valid?(:check_title_unique)
    return false unless errors.include?(:title)

    errors.details[:title].map { |v| v[:error] }.include?(:taken)
  end

  def allow_edit?(user)
    return false if user.blank?
    return false unless order_purchase_waiting?

    user_id == user.id
  end

  private

  def notify_slack_ordered
    message = <<~"MESSAGE"
      To: #{notify_to} #{user&.slack_name}から「#{title}」の注文依頼がありました。
      #{url}
    MESSAGE

    notify_slack message
  end

  def notify_to
    "@#{Rails.application.config.slack_notify_to}" || '@here'
  end

  def sanitized_isbn(isbn)
    isbn.to_s.delete('-').strip
  end

  def fetch_openbd(isbn)
    uri = URI.parse("https://api.openbd.jp/v1/get?isbn=#{CGI.escape(isbn)}")
    res = Net::HTTP.get_response(uri)
    raise OpenbdError, 'openBDへのリクエストに失敗しました。' unless res.is_a?(Net::HTTPSuccess)

    json = JSON.parse(res.body)
    json&.first
  rescue JSON::ParserError
    raise OpenbdError, 'openBDのレスポンス解析に失敗しました。'
  end

  class OpenbdError < StandardError; end
end
