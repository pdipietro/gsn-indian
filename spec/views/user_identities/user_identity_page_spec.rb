require 'spec_helper'
describe "user_identities/identity_page_spec.rb" do
	subject { page }
    
    describe "Edit page" do
    	before do
    	    create_user_identity
    	    sign_in(@identity, 'normal')			
    	    visit edit_user_identity_path(@identity)				
    	end   	        	

        it "user's profile changes" do      			
		    fill_in "Nickname", :with => "Test"
		    # fill_in "Last name", :with => "User"		    
            fill_in "Email", :with => "ankur.jain@ongraph.com"
            fill_in "Country", :with => "India"     
            fill_in "Password", :with => "foobar"    
            fill_in "Confirm Password", :with => "foobar"    
		    
		    click_button "Save changes"
		   page.should have_content('Profile updated')
		end

  	end

    describe "New page" do
        before do
            create_user_identity
            sign_in(@identity, 'normal')            
            visit new_user_identity_path             
        end         

        #it { page.should have_link( 'change', href: "http://gravatar.com/emails") }

        it "user's profile create" do                  
            fill_in "First name", :with => "Test"
            fill_in "Last name", :with => "User"            
            fill_in "Email address", :with => "#{Faker::Name.first_name}1222@gmail.com"
            find('#user_identity_country').find(:xpath, 'option[2]').select_option
            find('#user_identity_other_languages').find(:xpath, 'option[2]').select_option
            find('#user_identity_default_language').find(:xpath, 'option[2]').select_option
            
            fill_in "Password", :with => "foobar"    
            fill_in "Password Confirmation", :with => "foobar"    
            
            click_button "Create my account"
           page.should have_content('Identity successfully created')
        end
         
        # it "user's email can't be blank" do                  
        #     fill_in "First name", :with => "Test"
        #     fill_in "Last name", :with => "User"            
        #     find('#user_identity_country').find(:xpath, 'option[2]').select_option 
        #     find('#user_identity_other_languages').find(:xpath, 'option[2]').select_option
        #     find('#user_identity_default_language').find(:xpath, 'option[2]').select_option  
        #     fill_in "Password", :with => "foobar"    
        #     fill_in "Password Confirmation", :with => "foobar"    
            
        #     click_button "Create my account"
        #    page.should have_content("Email can't be blank")
        # end

        #  it "user's password can't be blank" do                  
        #     fill_in "First name", :with => "Test"
        #     fill_in "Last name", :with => "User" 
        #     fill_in "Email", :with => "#{Faker::Name.first_name}1222@gmail.com"           
        #     fill_in "Country", :with => "India"              
            
        #     click_button "Create my account"
        #    page.should have_content("Password is too short (minimum is 6 characters)")
        # end

        # it "user's email already exist" do                  
        #     fill_in "First name", :with => "Test"
        #     fill_in "Last name", :with => "User" 
        #     fill_in "Email", :with => UserIdentity.last.email          
        #     fill_in "Country", :with => "India"  
        #     fill_in "Password", :with => "foobar"    
        #     fill_in "Confirmation", :with => "foobar"            
            
        #     click_button "Create my account"
        #    page.should have_content(" Identity already created")
        # end

    end

    describe "Show page" do
        before do
            create_user_identity
            sign_in(@identity, 'normal')            
            visit user_identity_path(@identity.id)             
        end
        it { page.should have_link('Groups', href: groups_path(identity: @identity.uuid)) }
        # it { page.should have_selector('h1', text: @identity.email) }
        it { page.should have_css('#graph-container') }
        it { should render_template(:partial => '_graph_script') }
        it { should render_template(:partial => '_graph_template') }
    end
    
end
