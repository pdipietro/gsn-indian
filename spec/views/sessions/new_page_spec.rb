require 'spec_helper'
describe "sessions/new.html.erb" do
	subject { page }
    describe "New page" do
    	before { visit signin_path }      

        it "signs users in" do
		    fill_in "Email address", :with => "ankur.jain@ongraph.com"
		    fill_in "Password", :with => "foobar"
		    click_button "Sign in"

		    # page.should have_content('Signed in successfully')
		end

		it { page.should have_link('Sign up', href: signup_path) }
		
  	end

  	# describe "Oauth" do
	  # it "Signin using facebook" do
	  #   visit "/auth/facebook"
	  #   page.should have_content('Signed in successfully with facebook')
	  # end

	  # it "Signin using twitter" do
	  #   before do 
   #        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] 
   #      end
	  #   page.should have_content('Signed in successfully with twitter')
	  # end

	  # it "Signin using linkedin" do
	  #   visit "/auth/linkedin"
	  #   page.should have_content('Signed in successfully with linkedin')
	  # end

	  # it "Signin using gplus" do
	  #   visit "/auth/gplus"
	  #   page.should have_content('Signed in successfully with gplus')
	  # end
  		
  	# end

  	describe "oauth identities" do
	  context "without signing into app" do
        before { visit root_path }
	    it "twitter sign in button should lead to twitter authentication page" do	     
	      click_link "Twitter"
	      page.should have_content('Signed in successfully with twitter')
	    end

	    it "facebook sign in button should lead to facebook authentication page" do
	      click_link "Facebook"
	      page.should have_content('Signed in successfully with facebook')
	    end

	    it "linkedin sign in button should lead to linkedin authentication page" do
	      click_link "Linkedin"
	      page.should have_content('Signed in successfully with linkedin')
	    end

	    it "gplus sign in button should lead to gplus authentication page" do
	      click_link "Google +"
	      page.should have_content('Signed in successfully with gplus')
	    end

	  end
	end


end
