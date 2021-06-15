FactoryBot.define do
    factory :user do
        name { FFaker::Name.first_name }
        surname { FFaker::Name.last_name }
        email { "#{FFaker::Internet.user_name}@gmail.com" }
        password { '123456789' }
        password_confirmation { '123456789' }
    end
  end
  