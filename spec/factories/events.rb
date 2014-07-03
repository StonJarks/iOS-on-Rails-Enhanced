# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  sequence :lat do |n|
    "#{n}.0".to_f
  end

  sequence :lon do |n|
    "#{n}.0".to_f
  end

  sequence :name do |n|
    "name #{n}"
  end

	sequence :started_at do |n|
		Time.zone.now + n.hours
	end

	sequence :ended_at do |n|
		Time.zone.now + n*4.hours
	end
	
  factory :event do
    address "21 Jump Street"
    ended_at
    lat
    lon
    name
    started_at
    owner factory: :user
  end
end
