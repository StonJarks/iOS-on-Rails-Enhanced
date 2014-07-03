# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attendance do
    association :event, factory: :event
    association :user, factory: :user
  end
end
