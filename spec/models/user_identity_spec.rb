require 'spec_helper'

describe UserIdentity do   

  	it { should respond_to(:uid) }
  	it { should respond_to(:email) }
  	it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
  	it { should respond_to(:nickname) }
    
     user = FactoryGirl.create(:user) 
     identity = FactoryGirl.create(:identity) 
     user.identities << identity
     # identity.user = user
     identity.identity_provider("normal")

  	describe "UUID" do
    	it { identity.uid.should_not be_nil }
    end

	describe "email" do
    	it { identity.email.should_not be_nil }
	end
	
	
	describe "nickname" do
    	it { identity.nickname.should_not be_nil }
	end
  
  
  describe "when email address is already taken" do
    before do     
      identity_with_same_email = identity.dup
      identity_with_same_email.save
    end
    it { should_not be_valid }
  end


  describe "password mismatch " do
    before { identity.password_confirmation = "mismatch" }
    it { should_not be_valid }  
  end

  describe "password too short" do
    before { identity.password = identity.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  # describe "identity associations" do
  #   it "should have many providers" do      
  #     identity.providers.should be_a_kind_of(Array)
  #     identity.providers.should_not be_empty
  #   end
  # end


  describe "password " do
    before do
      UserIdentity.new(nickname: "example_user", email: "use223r@example.com", password: " ", password_confirmation: " ", uid: SecureRandom.uuid)
    end
    it { should_not be_blank }
  end

  # describe 'identity user association' do
  #   before(:each) do
  #     @event = Event.unsafe_create(@valid_attributes)
  #     @activity = Activity.find_by_item_id(@event)
  #   end
    
  #   it "should have an activity" do
  #     @activity.should_not be_nil
  #   end
    
  #   it "should add an activity to the creator" do
  #     @event.person.recent_activity.should contain(@activity)
  #   end
    
  # end

end

