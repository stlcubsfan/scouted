# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :position do
    symbol "MyString"
    purchase_price 1.5
    shares 1.5
    purchase_date "2013-10-31"
    sold_date "2013-10-31"
    sold_price 1.5
  end
end
