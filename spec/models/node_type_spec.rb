require 'spec_helper'

describe NodeType do
 
    node_type = FactoryGirl.create(:node_type)
 
 it { node_type.should respond_to(:field_name) }


    # describe "Field Name" do
    #   it { node_type.field_name.should be_nil }
 # end

 describe "has one is_owned_by" do
     create_user_identity
  node_type = NodeType.create(field_name: "description")
  node_type.is_owned_by = @user
     it { node_type.is_owned_by.should_not be_nil }
 end

 describe "has many node attributes" do
     create_user_identity
     node_attribute1 = FactoryGirl.create(:node_attribute)
     node_attribute2 = FactoryGirl.create(:node_attribute)
    node_type.properties << node_attribute1
    node_type.properties << node_attribute2
     it { node_type.properties.count.should >= 1 }
     it { should be_valid }
 end

end