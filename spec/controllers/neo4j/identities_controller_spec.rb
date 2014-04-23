require 'spec_helper'

describe Neo4j::IdentitiesController do
  subject { page }

  before(:each) do
    create_user_identity
  end

  describe 'GET #index' do
    let(:get_index) { get :index }
        @identities = Neo4j::Identity.all
    describe 'response' do
        before { get_index }
          it { assigns(:identities).should eql @identities }
        end
    end

    describe 'GET #new' do
    let(:get_new) { get :new }
        @user = Neo4j::Identity.new
    describe 'response' do
        before { get_new }
            it { should render_template :new }
      end
    end

    describe 'GET #edit' do
      before do
          user_sign_in(@identity)
          @identity = Neo4j::Identity.last
      end
      it "should edit the identity" do
          # visit edit_neo4j_identity_path(@identity)
          get :edit, id: @identity.id      
          assigns(:identity).should == @identity
      end
    end

    describe 'GET #show' do
      before do
          @identity = Neo4j::Identity.last
          user_sign_in(@identity)
      end
      it "should show the identity" do   
          get :show, id: @identity.id
          assigns(:identity).should eq(@identity)        
      end
    end

    describe 'PUT update' do
      before do
        @identity = Neo4j::Identity.last
        user_sign_in(@identity)
      end
      it "should update the identity and redirect" do
        patch :update, id: @identity.id, neo4j_identity: {country: "UK"}
        response.should redirect_to "/neo4j/identities/#{@identity.id}"
      end

      it "should_not update the identity and render" do
        patch :update, id: @identity.id, neo4j_identity: {email: ""}
        response.should be_successful
        response.should render_template("edit")
      end
    end
  
    describe "DELETE destroy identity" do

      before do
        @identity = Neo4j::Identity.last
        user_sign_in(@identity)
      end

      it "should destroy the identity" do
          delete :destroy, id: @identity.id
          response.should redirect_to neo4j_identities_url
      end
    end

end
