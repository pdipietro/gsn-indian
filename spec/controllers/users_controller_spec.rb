require 'spec_helper'

describe UsersController do

  before do
      create_user_identity
  end

	describe 'GET #index' do
		let(:get_index) { get :index }
        @users = User.all
    describe 'response' do
	    	before { get_index }
	        it { assigns(:users).should eql @users }
    end
  end

  # describe 'GET #show' do
  #   before do
  #     @identity = UserIdentity.find(conditions: {country:"Indoneasia"})
  #     user_sign_in(@identity)
  #   end
  #   it "should show the user" do
  #     get :show, id: @user.id
  #     assigns(:user).should == @user
  #   end
 	# end

 	describe 'GET #new' do
	  let(:get_new) { get :new }
    @user = User.new
    describe 'response' do
    	before { get_new }
      it { should render_template :new }
	  end
  end

  describe 'GET #edit' do
    before do
      @identity = UserIdentity.find(conditions: {country:"Indoneasia"})
      user_sign_in(@identity)
    end
    it "should edit the user" do
      get :edit, id: @user.id
      assigns(:user).should == @user
    end
  end

   describe 'PUT update' do
     before do
       @identity = UserIdentity.find(conditions: {country:"Indoneasia"})
       user_sign_in(@identity)
     end
     it "should update the user" do
       patch :update, id: @user.id, user: {country: "Africa"}
       response.should redirect_to "/users/#{@user.id}"
     end

     it "should not update the user" do
       patch :update, id: @user.id, user: {first_name: ''}
       response.should render_template("edit")
     end
  end

  describe 'POST create_relation' do
     before do
       @identity = UserIdentity.find(conditions: {country:"Indoneasia"})
       user_sign_in(@identity)
     end

     it "should create the relation" do
      end_node = Neo4j::Node.create( {:test => "hello"}, :Test )
       post :create_relation, id: @identity.id, "relationship"=>{"type"=>"HAS_PROVIDER", 
                                         "0"=>{"name"=>"test", "value"=>"test"}}, 
                                         "start_node"=> @identity.id, "end_node"=> end_node.neo_id
       response.should redirect_to "/users/#{@user.id}"
     end
    
  end
  
  describe "should destroy user" do  
    before do
       @identity = UserIdentity.find(conditions: {country:"Indoneasia"})
       user_sign_in(@identity)
    end

    it "should destroy the identities if the user is destroyed" do
      idenitities = @user.identities.map{|identity| identity}
      delete :destroy, id: @user.id
      idenitities.each do |identity|
        identity.should_not exist_in_database
      end
    end

    it "should destroy the user" do
      delete :destroy, id: @user.id
      response.should redirect_to users_path
    end
  end
end
