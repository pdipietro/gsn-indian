class NodeTypesController < ApplicationController

	def index
		@node_types = NodeType.all
	end

	def new
		@node_type = NodeType.new
		node_attributes
	end

	def create
		@node_type = NodeType.new(node_type_params)				
		if @node_type.save
		  @node_type.is_owned_by = current_user
		  params["node_attr_type"] ||= []
		  params["node_attr_type"].each do |key, val|
		  	
		  	if val.present?
			  	property = NodeAttribute.find(val)
			    @node_type.properties << property
			end
		  end

		  if @node_type.properties.blank?
		  	@node_type.destroy
		  	node_attributes
		  	flash.now[:error] = 'Node Type has at least one node attribute'
		  	render 'new'
		  else
		    redirect_to node_types_path(identity: current_identity.uuid)
		  end
		else
		  render 'new'
		end
	end
   
   private

	def node_type_params
	  params.require(:node_type).permit(:field_name)
	end

	def node_attributes
		hash_attributes = {}
    	attributes = NodeAttribute.all
    	attributes.each do |attr|
    	  hash_attributes[attr.attr_type] = []  unless hash_attributes.has_key? attr.attr_type
    	  hash_attributes[attr.attr_type] << [attr.name, attr.id]
    	end
    	@attributes = hash_attributes
	end

	
end
