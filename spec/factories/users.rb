FactoryGirl.define do
  factory :user do   
   first_name "john"
   last_name "josh"
   country "Australia"
   default_language "en"
   other_languages ["en"]
   ns "ki"

   # factory :user_with_identity do
   #   after(:create) do |user|
   #     identity = FactoryGirl.create(:identity) 
   #     user.identities << identity
   #     identity.user = user

   #   end
   # end

end
end
