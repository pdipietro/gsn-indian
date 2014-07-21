# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :identity, class: UserIdentity do
    uid SecureRandom.uuid
     # sequence(:email) { |n| "user_#{n}@example.com" }
    sequence(:email){|n| "#{Faker::Name.first_name}#{n}@factory.com" }   
    password "foobar"
    password_confirmation "foobar"
    country "Indoneasia"
    remember_token SecureRandom.urlsafe_base64
    confirmation_token UserIdentity.hash(UserIdentity.new_random_token)
    confirmation_sent_at Time.now.utc
    ns "ki"
   


    # factory :identity_with_provider do
    #   after(:create) do |identity|        
    #     identity.identity_provider("normal")     
    #   end
    # end

    # factory :identity_with_user do
    #   after(:create) do |identity|        
    #     user.identities << identity
    #     identity.user = user     
    #   end
    # end

  end


end
