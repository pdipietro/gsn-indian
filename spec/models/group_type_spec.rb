# require 'spec_helper'

# describe GroupType do


#     describe "grouptype relationships" do
#         create_user_identity
#         group_type = GroupType.create()
#         name_node_type = NodeType.find(conditions: {field_name: 'name'})
#         desc_node_type = NodeType.find(conditions: {field_name: 'description'})

#         group_type.node_types << name_node_type
#         group_type.node_types << desc_node_type

#         group_type.is_owned_by = @user

#         it { group_type.is_owned_by.should_not be_nil }

#         it { group_type.node_types.count.should > 1 }
#     end

# end
