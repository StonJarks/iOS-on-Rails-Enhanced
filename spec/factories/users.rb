# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

	sequence :email do |n|
		"user#{n}@example.com"
	end

  factory :user do
  	email
  	salt "asdasdastr4325234324sdfds"
  	password "secret"
  	#password_confirmation "foobar"
  	crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt("secret", 
                     "asdasdastr4325234324sdfds") }
  end
end
