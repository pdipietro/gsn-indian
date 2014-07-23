require 'spec_helper'

describe NodeTypesController do

	before do
      create_user_identity
    end
	describe 'GET #index' do
		before do
	       @identity = UserIdentity.find(conditions: {country:"Indoneasia"})
	       user_sign_in(@identity)
	    end
		let(:get_index) { get :index }
        @node_types = NodeType.all
	    describe 'response' do
	    	before { get_index }
	        it {  should render_template :index }
	    end
    end

    describe 'GET #new' do
    	before do
	       @identity = UserIdentity.find(conditions: {country:"Indoneasia"})
	       user_sign_in(@identity)
	    end
		  let(:get_new) { get :new }
	      @node_type = NodeType.new
	      describe 'response' do
	    	before { get_new }
	        it { should render_template :new }
		  end
    end

    describe 'POST #create' do
    	before do
	       @identity = UserIdentity.find(conditions: {country:"Indoneasia"})
	       user_sign_in(@identity)
	       @node_attribute = FactoryGirl.create(:node_attribute)

	    end

		it "should create & save the node type" do
	       post :create, id: @identity.id, node_type: { field_name: "attr1" }, 
	                                                    node_attr_type: {"#{@node_attribute.attr_type}" => "#{@node_attribute.id}"}
	       response.should redirect_to "/node_types"
	    end

	    # it "should not create & save the node type" do
	    #    post :create, id: @identity.id,  node_attr_type: {"#{@node_attribute.attr_type}" => "#{@node_attribute.id}"}
	    #     response.should be_successful
	    #     response.should render_template "new"
	    # end
    end
end
