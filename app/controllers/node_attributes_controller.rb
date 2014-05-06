class NodeAttributesController < ApplicationController
    before_action :signed_in_user

    def index
    	hash_attributes = {}
    	attributes = NodeAttribute.all
    	attributes.each do |attr|
    	  hash_attributes[attr.attr_type] = []  unless hash_attributes.has_key? attr.attr_type
    	  hash_attributes[attr.attr_type] << attr.name
    	end
    	@attributes = hash_attributes
    end
    
	def create		
		@attribute_type = NodeAttribute.new(attribute_type_params)	
		if @attribute_type.save
		  @attribute_type.creator = current_user
		  redirect_to node_attributes_path(identity: current_identity.uuid)
		else
		  render 'new'
		end
	end

	def new		
       @attribute_type = NodeAttribute.new
	end

	# private

    def attribute_type_params
      params.require(:node_attribute).permit(:name, :attr_type)
    end

end
