FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    slack_member
  end
end
