# for order
class Order < ApplicationRecord
  belongs_to :user
  has_one :book
  enum state: { order_purchase_waiting: 0, order_purchased: 10 }

  attr_reader :parsed_title, :parsed_image_path, :parsed_html

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
    elements
  end
end
