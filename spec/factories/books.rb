FactoryBot.define do
  factory :book do
    title { 'MyString' }
    location { 'MyText' }
    order { create(:order) }

    trait :rentaled do
      user { create(:user) }
    end
  end
end
