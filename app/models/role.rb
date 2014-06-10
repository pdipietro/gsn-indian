class Role 
    include Neo4j::ActiveNode
    property :id
    property :name
    has_one(:is_owned_by).from(:users)
end