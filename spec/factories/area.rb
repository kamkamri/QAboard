FactoryBot.define do
  factory :area do
    # name { Faker::Lorem.characters(number: 4) }
    sequence(:name) { |n| "本社#{n}" }

    # after(:build) do |end_user|
    #   end_user.profile_image.attach(io: File.open('spec/images/profile_image.jpeg'), filename: 'profile_image.jpeg', content_type: 'application/xlsx')
    # end
  end


    # after(:build) do |end_user|
    #   end_user.profile_image.attach(io: File.open('spec/images/profile_image.jpeg'), filename: 'profile_image.jpeg', content_type: 'application/xlsx')
    # end
end