FactoryBot.define do
  factory :book do
    title { Faker::Lorem.characters(number: 10) }
    opinion { Faker::Lorem.characters(number: 30) }
  end
end