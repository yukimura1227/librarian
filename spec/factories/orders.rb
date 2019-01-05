FactoryBot.define do
  factory :order do
    title { Faker::Book.title }
    order_time { Time.zone.now }
    state { 0 }
    url { Faker::Internet.url }
    user
  end
end
