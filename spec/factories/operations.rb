FactoryBot.define do
  factory :operation do
    type { 'Operation' }
    user
    book
  end
  factory :rental_operation, parent: :operation, class: Operation::Rental do
    type { 'Operation::Rental' }
  end
end
