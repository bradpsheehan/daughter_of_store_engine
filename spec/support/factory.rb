FactoryGirl.define do

  factory :category do
    title 'Dark Matter'
  end

  factory :order_item do
    product { FactoryGirl.build(:product) }
    order { FactoryGirl.build(:order) }
    unit_price 20.00
    quantity 3
  end

  factory :order do
    status 'pending'
  end

  factory :product do
    categories { [FactoryGirl.build(:category)] }
    title 'Itchy Sweater'
    description 'Hurts so good'
    price 12.99
    status 'active'
    promotion 0
  end

  factory :user do
    full_name 'Brad Sheehan'
    email 'brad@example.com'
    display_name 'bradsheehan'
    password 'password'

    factory :invalid_user do
      full_name nil
    end
  end

  factory :uber, parent: :user do
    full_name 'Chris Knight'
    email 'chris@example.com'
    display_name 'knight'
    password 'password'
    uber true
  end

  factory :address do
    street  '43 Logan Street'
    state   'CA'
    zipcode '90100'
    city    'The Angels'
  end

  factory :store do
    name  'Da best'
    description   'The bestest store'
    path 'a-store'
    status 'online'
  end

  factory :user_store_role do
    store_id 1
    user_id 1
    role 'admin'
  end

end
