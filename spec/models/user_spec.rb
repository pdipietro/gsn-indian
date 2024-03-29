require 'spec_helper'

describe User do

	it { should respond_to(:uuid) }
	it { should respond_to(:first_name) }
	it { should respond_to(:last_name) }
	it { should respond_to(:country) }

    user = FactoryGirl.create(:user)
    
    describe "UUID" do
    	it { user.uuid.should_not be_nil }
	end

	describe "First Name" do
    	it { user.first_name.should_not be_nil }
	end	

	describe "Last Name" do
    	it { user.last_name.should_not be_nil }
	end

	describe "Country" do
    	it { user.country.should_not be_nil }
 	end  	
 	
 	describe "user identity" do
 		it { user.identities.should_not be_nil }
 	end

 	describe "many identities" do
 	  before do
 	  	identity = FactoryGirl.create(:identity) 	  	
 	  	user.identities << identity
 	  	# identity.user = user
 	  	identity.identity_provider("normal")
 	  end
       it {  user.identities.count > 1 }
       it { user.should be_valid }
    end


end
	