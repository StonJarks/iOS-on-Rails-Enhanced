# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    name "Event image"
    image { File.new("#{Rails.root}/spec/support/fixtures/image.jpg") }
    event factory: :event
  end
end
