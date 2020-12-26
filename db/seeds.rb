User.create!(name: "Admin",
  email: "admin@gmail.com",
  password: "123123",
  password_confirmation: "123123",
  role: 0
)

#User
30.times do |n|
  User.create!(
    name: Faker::Name.name,
    email: "example#{n+1}@gmail.com",
    password:"123123",
    password_confirmation: "123123",
    phone_number: Faker::Number.leading_zero_number(digits: 10)
  )
end

# Categories
Category.create!(name: "Foods")
Category.create!(name: "Drinks")
foods=["Korean","Japanese","Chinese","Vietnam","Pizza","French"]
foods.each do |food|
  Category.create!(
    name: food,
    parent_id: Category.limit(1).pluck(:id).sample
  )
end

# Products
categories=Category.where(parent_id: nil)
subCategories= Category.all-categories
30.times do |n|
  Product.create!(
    category_id: subCategories.pluck(:id).sample,
    name: Faker::Food.dish,
    description: Faker::Food.description,
    price: Faker::Number.decimal(l_digits: 2),
    quantity: Faker::Number.non_zero_digit,
  )
end

# Vouchers
4.times do |n|
  Voucher.create!(
    name: Faker::Commerce.promotion_code,
    discount: Faker::Number.decimal(l_digits: 1, r_digits: 2),
    condition:Faker::Number.decimal(l_digits: 2)
  )
end

# Orders
12.times do |n|
  Order.create!(
    user_id: User.pluck(:id).sample,
    status: Order.statuses.values.sample,
    delivery_time: Faker::Time.backward(days: 14),
    phone_number: Faker::Number.leading_zero_number(digits: 10),
    address: Faker::Address.full_address,
    name: Faker::Name.name
  )
end

# Orders Details
orders=Order.all
orders.each do |order|
  3.times do |n|
    OrderDetail.create!(
      order_id: order.id,
      product_id: Product.pluck(:id).sample,
      price: Faker::Number.decimal(l_digits: 2),
      quantity: rand(1..10)
    )
  end
end

# Ratings
10.times do |n|
  Rating.create!(
    user_id: User.pluck(:id).sample,
    product_id: Product.pluck(:id).sample,
    rating: rand(1..5)
  )
end
