require 'spec_helper'

describe StaticPagesController do

	describe 'GET home' do
		context 'user not signed in' do
		  
		  # it 'should return http success' do
		  #   get :home
		  #   response.should be_success
		  # end

		  # it 'should render home page' do
		  #   get :home
		  #   response.should render_template 'home'
		  # end

		  it 'should assign use_default_layout to false' do
		    get :home
		    assigns(:use_default_layout).should be_false
		  end
		 
		end    
	end

end

