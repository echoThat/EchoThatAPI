FactoryGirl.define do
  factory :user do

    factory :valid_user do
      google_credentials "gmailjane"
      chrome_token {User.generate_token}
      always_link false
      facebook_char_floor 140
      twitter_name "follaback"
    end

    factory :invalid_user do
      google_credentials ""
    end

  end
end
