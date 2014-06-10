class NodeAttribute #< DefaultProperty
  
  include Neo4j::ActiveNode
  include CustomNeo4j 

  attr_accessor :avatar_attribute
  # include Neo4jrb::Paperclip

  property :id
  property :created_at, type: DateTime
  property :updated_at, type: DateTime
  property :uuid 

  property :name
  property :attr_type
  property :color, default: "#FFFF00"

  property :content_type 
  property :filename 

  validates :name, presence: true
  validate :name_uniqueness
  # has_neo4jrb_attached_file :avatar_attribute

  has_one(:is_owned_by).from(:users)
  before_save { self.name = name.downcase }
  before_save :set_file_attribute, if: Proc.new { |model| model.avatar_attribute.present? }
  after_save :upload_file, if: Proc.new { |model| model.avatar_attribute.present? }

  def name_uniqueness   
    if name.present?      
      n_attribute = NodeAttribute.find(name: name.try(:downcase), attr_type: attr_type ) 
      if n_attribute.present? and (n_attribute.name_changed? or new_record?)        
         errors.add(:name, "already exist.")
      end
    end
  end



  # def self.save(upload)
  #   name =  upload['datafile'].original_filename
  #   directory = "public/data"
  #   # create the file path
  #   path = File.join(directory, name)
  #   # write the file
  #   File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  # end

end