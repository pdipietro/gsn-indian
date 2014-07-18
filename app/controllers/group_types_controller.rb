class GroupTypesController < ApplicationController
   include CustomNodeRelationship

	def index
      @group_type = GroupType.all.map{|gt| gt}[0]
      @groups = {}
      @groups[:nodes] = []
      @groups[:edges] = []
      @check_node = []
      check_node_type = []
        check_node_attr = []
      if @group_type.present?
        
        rel_group_types = @group_type.rels(dir: :outgoing)
        rel_group_types.each do |rel_group_type|
          rel_group_name = rel_group_type.load_resource
          e_node = rel_group_type.end_node
          e_node_id = rel_group_type.end_node.neo_id
          s_node = rel_group_type._start_node
          edge_relation = rel_group_name.present? ? rel_group_name["type"] : ""
          # color_prop = r.end_node.props[:color].present? ? r.end_node.props[:color] : '#666'

          unless check_node_type.include? e_node_id
            check_node_type << e_node_id
            @groups[:nodes] << create_node(node: e_node, relation: edge_relation, label: e_node.labels[0], color: "#1928F8")
            rel_node_types = rel_group_type.end_node.rels(dir: :outgoing)
            rel_node_types.each do |rel_nt|
              rel_nt_type = rel_nt.load_resource
              e_node_nt = rel_nt.end_node
              e_node_nt_id = rel_nt.end_node.neo_id
              s_node_nt = rel_nt._start_node
              nt_edge_relation = rel_nt_type.present? ? rel_nt_type["type"] : ""
              # nt_color_prop = rel_nt.end_node.props[:color].present? ? rel_nt.end_node.props[:color] : '#666'
            
              
              unless check_node_attr.include? e_node_nt_id
                check_node_attr << e_node_nt_id
                @groups[:nodes] << create_node(node: e_node_nt, relation: nt_edge_relation, label: e_node_nt.labels[0], color: "#19E6F8")
              end
              @groups[:edges] << create_edge(source: s_node_nt, target: e_node_nt, relation: rel_nt, color: '#ccc', relation_name: nt_edge_relation)
            end
          end
          @groups[:edges] << create_edge(source: s_node, target: e_node, relation: rel_group_type, color: '#ccc', relation_name: edge_relation)
        end
        @groups[:nodes] << create_node(node: current_user, label: current_user.labels[0], color: '#F81960')
   

        @groups[:nodes] << create_node(node: @group_type, label: @group_type.labels[0], color: '#E2F819')
        relation_user_gt =  @group_type.rels(type: "users", dir: :incoming, between: Neo4j::Node.load(current_user.id))[0]
        if relation_user_gt.present?
         
          relation_user_gt_type = relation_user_gt.load_resource["type"]
          @groups[:edges] << create_edge(source: current_user, target: @group_type, relation: relation_user_gt, color: '#ccc', relation_name: relation_user_gt_type)
        end
        @check_node = check_node_type + check_node_attr
        @check_node << @group_type.neo_id
      end

   
	end

	def new
      @group_type = GroupType.new
      @node_types = NodeType.all
	end

	def edit
	end

	def create

		@group_type = GroupType.new()
		if @group_type.save
		  @group_type.is_owned_by = current_user
		  if params[:node_types].present?
			  params[:node_types].each do |nt|
			  	node_type = NodeType.find(nt)
			  	@group_type.node_types << node_type if node_type.present?
			  end
		  end

		  if @group_type.node_types.present? and @group_type.has_name_desc?
		  	redirect_to group_types_path
		  else
		  	@group_type.destroy
		  	@node_types = NodeType.all
		  	flash.now[:error] = 'Group Type must contains name and description node type'
		  	render 'new'
		  end
		else
		  render 'new'
		end

	end


end
