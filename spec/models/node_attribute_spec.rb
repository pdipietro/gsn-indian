require 'spec_helper'

describe NodeAttribute do

    it { should respond_to(:name) }
    it { should respond_to(:attr_type) }

 node_attribute = FactoryGirl.create(:node_attribute)
    
    describe "Name" do
     it { node_attribute.name.should_not be_nil }
 end

 describe "Name should be Unique" do
  last_node = NodeAttribute.last
  NodeAttribute.create(name: "#{last_node.name}", attr_type: "DataType")
     it { should_not be_valid }
 end 

 describe "has one is_owned_by" do
       create_user_identity
    node_attribute = NodeAttribute.create(name: Faker::Name.first_name, attr_type: "DataType")
    node_attribute.is_owned_by = @user
       it { node_attribute.is_owned_by.should_not be_nil }
 end
end
