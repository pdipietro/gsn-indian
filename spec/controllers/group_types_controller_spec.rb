require 'spec_helper'

describe GroupTypesController do
	

	describe 'GET #index' do
		before do
	     create_user_identity
	     sign_in(@identity, 'normal')
	    end
		let(:get_index) { get :index }
        describe 'response' do
	    	before { get_index }
	        it { should render_template :index }
        end
    end

	describe 'GET #new' do
		before do
		    create_user_identity
		    sign_in(@identity, 'normal')
	    end
	     let(:get_new) { get :new }
	    describe 'response' do
	    	before { get_new }
	        it { should render_template :new }
	    end
    end

    describe 'POST #create' do
		before do
		    create_user_identity
		    sign_in(@identity, 'normal')
		   node_attribute = FactoryGirl.create(:node_attribute)
		   @node_type = FactoryGirl.create(:node_type)
		   @node_type.properties << node_attribute
	    end
	     
	    # it "should create the node attributes and redirect" do
	    # 	node_name = NodeType.find(field_name: "name" )
	    # 	node_desc = NodeType.find(field_name: "description" )
	    #    post :create, node_types: [node_name.id, node_desc.id] 
	    #    response.should redirect_to group_types_path
	    # end

	    it "should not create the node attributes and render" do
	       post :create, node_types: ["#{@node_type.id}"] 
	       response.should render_template "new"
	    end
    end
end
