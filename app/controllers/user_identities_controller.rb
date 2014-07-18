class UserIdentitiesController < ApplicationController
  include CustomNodeRelationship

	before_action :signed_in_user, except: [:new, :create]
  before_action :correct_user,   only: [:edit, :update]
  # before_action :admin_user,     only: :destroy

  def index
   @identities = UserIdentity.all
  end

  def show
    @identity = UserIdentity.find(params[:id])
    @providers = {}
    @providers[:nodes] = []
    @providers[:edges] = []
    @check_node = []
    # random_num = Random.rand(1-6664664646)
     rel_identities = @identity.rels(type: :provider)
     rel_identities.each do |r_identity|
         
       e_node = r_identity.end_node
       e_node_id = r_identity.end_node.neo_id
       s_node = r_identity.start_node 
       s_node_id = r_identity.start_node.neo_id
       edge_properties = r_identity.props
       edge_relation_resource = r_identity.load_resource
       edge_relation = edge_relation_resource.present? ? edge_relation_resource["type"] : ""
       color_prop = r_identity.end_node.props[:color].present? ? r_identity.end_node.props[:color] : '#666'
       unless @check_node.include? e_node_id
         @check_node << e_node_id
         @providers[:nodes] << create_node(node: e_node, relation: edge_relation, label: e_node.labels[0], color: color_prop)
          
       end
       @providers[:edges] << create_edge(source: s_node, target: e_node, relsation: r_identity, color: '#ccc', relation_name: edge_relation)
     end
   
     @providers[:nodes] << create_node(node: @identity, label: @identity.labels[0], color: @identity.props[:color])
     @providers[:edges] << create_edge(source: current_user, target: @identity, relation: @identity.rels(type: 'User#identities')[0], color: '#ccc', relation_name: 'User#identities')
     @providers[:nodes] << create_node(node: current_user, label: current_user.labels[0], color: current_user.props[:color])
   
  end

  def new
    # @identity = UserIdentity.new
     new_identity
  end

  def edit
    @identity = UserIdentity.find(params[:id])
  end

  def update
    @identity = UserIdentity.find(params[:id])
    if @identity.update_attributes(identity_params)
      flash[:success] = "Profile updated"
      redirect_to @identity
    else
      render 'edit'
    end
  end

  def create
    # @identity = UserIdentity.new(identity_params)
    # if @identity.save
    @exist_identity =  UserIdentity.find(conditions: {email: params[:user_identity][:email_address].downcase}) 
    if @exist_identity.blank?        
      if signed_in?
         @user = current_user
      else    
        @user = User.new(first_name: params[:user_identity][:first_name],
                       last_name: params[:user_identity][:last_name], 
                       country: params[:user_identity][:country],
                       other_languages: params[:user_identity][:other_languages],
                       default_language: params[:user_identity][:default_language],                       
                       ns: "ki"
                   ) 


        # user.create_users_relation                      
      end

    if @user.save
      @identity = UserIdentity.new(country: params[:user_identity][:country], 
        email:  params[:user_identity][:email_address], password: params[:user_identity][:password], 
        password_confirmation: params[:user_identity][:password_confirmation], 
        nickname: "#{params[:user_identity][:first_name]} #{params[:user_identity][:last_name]}", 
        ns: "ki")

      if @identity.save
        @user.identities << @identity 
        # @identity.user = user
        @identity.identity_provider("normal")
        
        flash[:success] = signed_in? ? "Identity successfully created" : "Please verify your email"        
        redirect_to @identity
      else
        show_flash_error_messages(@identity)
        new_identity
        render 'new'
      end
    else
      show_flash_error_messages(@user)     
      new_identity
      render 'new'
    end
    else
      relation =  @exist_identity.identity_provider("normal")

      if relation == :error_messsage
        @identity = @exist_identity
        flash[:danger] = "Identity already created"      
        render 'new'
      end
    end
  end

  def destroy
    UserIdentity.find(params[:id]).destroy
    flash[:success] = "Identity deleted."
    redirect_to user_identities_url
  end

  def nodes
    current_user.rels
    # neo = Neography::Rest.new
    # cypher_query =  " START node = node:nodes_index(type='User')"
    # cypher_query << " RETURN ID(node), node"
    # neo.execute_query(cypher_query)["data"].collect{|n| {"id" => n[0]}.merge(n[1]["data"])}
  end  

 def edges
  # neo = Neography::Rest.new
  # cypher_query =  " START source = node:nodes_index(type='User')"
  # cypher_query << " MATCH source -[rel]-> target"
  # cypher_query << " RETURN ID(rel), ID(source), ID(target)"
  # neo.execute_query(cypher_query)["data"].collect{|n| {"id" => n[0], "source" => n[1], "target" => n[2]} }
 end

  private

    def identity_params
      # params.require(:user_identity).permit(:email, :password,
      #                              :password_confirmation, :first_name, :last_name, :country)
      params.permit!
    end

    # Before filters

    def correct_user
      user_id = UserIdentity.find(params[:id]).user.neo_id
      user = User.find(user_id)
      redirect_to(root_url) unless current_user?(user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin
    end

    def new_identity
      user_identity_fields = UserIdentity.user_identity_fields
      user_fields = Neo4j::Session.query('match (n:Model{name: "user"})-[:_HAS]->(m{complex: "false"})-[:_]->(t)-[:_IS_A]->(s) 
        return m.name, m.cardinality, s.name;').data
      user_form_fields = user_fields + user_identity_fields
      # user_form_fields.delete(["remember token", "1", "string"])
      # user_form_fields.delete(["password digest", "1", "string"])
      # user_form_fields << ["password", "1", "string"]
      # user_form_fields << ["password_confirmation", "1", "string"]
      @user_form_fields = user_form_fields
    end

  
    
end
