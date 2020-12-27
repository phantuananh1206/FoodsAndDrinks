FactoryBot.define do
  factory :product do
    name { "Fish and Chips" }
    quantity { 10 }
    price { 90 }
    category_id { 1 }
  end
end
