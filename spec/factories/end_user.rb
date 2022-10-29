FactoryBot.define do
  factory :end_user do
    employee_number { Faker::Lorem.characters(number: 6, min_numeric:6) }
    family_name { Faker::Lorem.characters(number: 2) }
    first_name { Faker::Lorem.characters(number: 2) }
    # area_id { Faker::Number.between(from: 2, to: 4)} #5以上11以下をランダム生成
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

    association :area #←追記

    # after(:build) do |end_user|
    #   end_user.profile_image.attach(io: File.open('spec/images/profile_image.jpeg'), filename: 'profile_image.jpeg', content_type: 'application/xlsx')
    # end
  end
end