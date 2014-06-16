require 'spec_helper'
describe "static_pages/home.html.erb" do

  subject { page }
   
  describe "Home page" do

    describe "for signed-in users" do
	   	before do
		  create_user_identity					
		  sign_in(@identity, 'normal')
    	end
	    

	    it "should render the user's page " do
		    render
		    page.should render_template("shared/_search_node")
		    page.should render_template("shared/_header_profile_modal")
	    end
    end

    describe "for unsigned-in users" do
    	before do
		  create_user_identity					
		  sign_in(@identity, 'normal')
		  visit signout_path
    	end
	    # it { page.should have_selector('h1', text: 'Sample App') }
	    # it { page.should have_selector('h2', text: 'home page') }	    
	    it { page.should have_link( 'GSN', href: root_path) }
	    it { page.should have_link( 'Sign up', href: signup_path) }	
    end
  end
end