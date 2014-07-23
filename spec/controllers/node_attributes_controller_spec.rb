require 'spec_helper'
describe NodeAttributesController do
	node_attributes = FactoryGirl.create(:node_attribute)
	before do
      create_user_identity
    end
	describe 'GET #index' do
		before do
	       @identity = UserIdentity.find(conditions: {country:"Indoneasia"})
	       user_sign_in(@identity)
	    end
		let(:get_index) { get :index }
        attributes = NodeAttribute.all
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
	      @attribute_type = NodeAttribute.new
	      describe 'response' do
	    	before { get_new }
	        it { should render_template :new }
		  end
    end


    describe 'POST #create' do
    	before do
	       @identity = UserIdentity.find(conditions: {country:"Indoneasia"})
	       user_sign_in(@identity)
	    end
		it "node attributes not saved then render" do
	       post :create, id: @identity.id, node_attribute: {name: "#{NodeAttribute.last.name}", attr_type: 'DataType' }
	       response.should render_template "new"
	    end

	    it "should create the node attributes and redirect" do
	       post :create, id: @identity.id, node_attribute: {name: "#{Faker::Name.name}", attr_type: 'DataType' }
	       response.should redirect_to "/node_attributes"
	    end

    end
end
