class GroupsController < ApplicationController
    include CustomNodeRelationship

	def index
		
     @groups = current_identity.groups

	# Neo4j::Session.current.find_all_nodes(:Groupss) 
		
	end

	def new
      # @group = Group.new
      group_types = GroupType.all.map{|gt| gt}[0]
      @node_types = group_types.try(:node_types)
	end

	def edit
	end

	def create			
		params[:node_types][:color] = "#FF00FF"
		params[:node_types][:created_at] = Time.now.to_i
		params[:node_types][:updated_at] = Time.now.to_i
		group = Neo4j::Node.create(params[:node_types], :Group)
		identity_group = current_identity.create_rel(:groups, group)
        group_owner = group.create_rel(:is_owned_by, current_identity)		
		redirect_to groups_path(identity: current_identity.uuid)		
	end

	def show
		@group = Neo4j::Node.load(params[:id])	
	    @groups = {}
	    @groups[:nodes] = []
	    @groups[:edges] = []
	    
		  e_node = @group
		  s_node = current_identity
		  e_relation = @group.rels(type: :groups, dir: :incoming, between: Neo4j::Node.load(current_identity.id))[0]	
		  # edge_relation = e_relation.load_resource.present? ? e_relation.load_resource["type"] : ""
		  e_relation_user = current_identity.rels(type: "User#identities", dir: :incoming, between: Neo4j::Node.load(current_user.id))[0]
		  # color_prop = r.end_node.props[:color].present? ? r.end_node.props[:color] : '#666'
	    @groups[:nodes] << create_node(node: e_node, relation: "groups", label: e_node.labels[0], color: e_node.props[:color])
	    @groups[:nodes] << create_node(node: s_node, relation: "groups", label: s_node.labels[0], color: s_node.props[:color])
	    @groups[:nodes] << create_node(node: current_user, label: current_user.labels[0], color: current_user.props[:color])
	    @groups[:edges] << create_edge(source: s_node, target: e_node, relation: e_relation, color: '#ccc')
	    @groups[:edges] << create_edge(source: current_user, target: s_node, relation: e_relation_user, color: '#ccc')
	    @check_node = [e_node.neo_id, s_node.neo_id, current_user.neo_id]
	end

	

end
