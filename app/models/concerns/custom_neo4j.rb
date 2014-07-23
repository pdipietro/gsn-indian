
module CustomNeo4j
  extend ActiveSupport::Concern
 
  	# def new_labels(*labels)	
  	# 	id = self.neo_id
  		# MATCH (n { name : "dfdfsd" })
    #       SET n :German
    #       RETURN n;		
   
  	# end

    # def new_labels(*labels) 
    #   id = self.neo_id
    #   Rails.logger.debug ":::::::::::::::::::::::::::::::::::::::::::::::"
    #   Rails.logger.debug labels.inspect
    #   Rails.logger.debug id
    #   label = labels[0].to_sym
    #   # Rails.logger.debug Neo4j::Cypher.query{"MATCH (n) WHERE id(n) = #{id} SET n #{label} RETURN n;"}.to_s
    #   Rails.logger.debug Neo4j::Cypher.query{'MATCH (n { nickname : "puneetong" }) SET n :dsasdsda RETURN n;'}.to_s
    #   Rails.logger.debug Neo4j::Cypher.query{'START n= node(1837) SET n :dadad RETURN n;'}.to_s
        
  #       match (n {id:1})
  # set n :newLlabel
  # return n 

    # end

  

  ATTRIBUTE_TYPES = ['Visibility', 'DataType', 'Requirement']
  
	 module ClassMethods
   		def first
     		all.map{|u| u}[0]
    	end

    	def last
       		count = all.count
       		all.map{|u| u}[count - 1]
    	end

      def sanitize_filename(file_name)
        # get only the filename, not the whole path (from IE)
        just_filename = File.basename(file_name) 
        # replace all none alphanumeric, underscore or perioids
        # with underscore
        just_filename.sub(/[^\w\.\-]/,'_') 
      end



  
  	end

  # def avatar_attribute=(input_data)

  #   name = input_data.original_filename
  #   content_type = input_data.content_type.chomp
  #   directory = "tmp/uploads/#{Time.now.to_i}"
  #   FileUtils.mkdir directory
  #   # create the file path
  #   path = File.join(directory, name)
  #   # write the file
  #   File.open(path, "wb") { |f| f.write(input_data.read) }
  #   self.filename = input_data.original_filename
  #   self.content_type = input_data.content_type.chomp  

  # end
  def  set_file_attribute
    self.filename = self.avatar_attribute.original_filename
    self.content_type = self.avatar_attribute.content_type.chomp  
  end


  def upload_file

    input_data = self.avatar_attribute
    
    name = input_data.original_filename
    content_type = input_data.content_type.chomp
    directory_path = "public/systems/#{self.uuid}"
    directory_path_original = "public/systems/#{self.uuid}/original"
    directory_path_small = "public/systems/#{self.uuid}/small"
    FileUtils::mkdir_p directory_path_original
    FileUtils::mkdir_p directory_path_small
    # create the file path
    original_path = File.join(directory_path_original, name)
    small_path    = File.join(directory_path_small, name)
    # write the file
    File.open(original_path, "wb") { |f| f.write(input_data.read) }
    system("convert -size 70x70  #{original_path}  -resize '70x70^' -gravity center -crop '70x70+0+0'  #{small_path} ")
  
  end

  def get_social_network
     Neo4j::Label.find_all_nodes(:Social_Network)
  end
  
   def get_version
    app_version = Neo4j::Session.query('match (n:Build{name: "3.0.0"}) return ID(n)').data.flatten.first  
    varsion_model = Neo4j::Node.load(app_version)
  end

  def get_translation
    # Neo4j::Node.load()
  end

  def get_translation text, language
    node = Neo4j::Node.create({language: language, text: text}, :Translation)
    node.create_rel(:_HAS_VERSION, get_version)
    return node
  end   

  def add_underscore(str)
    str.downcase.tr(" ", "_")
  end

  def is_required_fields? cardinality
    ['1', '[1::*]'].include?cardinality
  end

  def validate_field field_attributes
    field_attributes.each do |attr|
      name = add_underscore(attr[0])
      cardinality = attr[1]
      id = attr[3].to_i
      pattern =Neo4j::Session.query("START n=node(#{id}) MATCH (n)-[:_]->(m)-[:_HAS_CONSTRAINT]->(s) return s.`has pattern`").data.flatten.first 
      regexp = pattern.present? ? (Regexp.new pattern) : nil
      value = self.send("#{name}")
      
      if (is_required_fields? cardinality) and (value.blank?)
        errors.add(name.to_sym, "can't be blank.") 
      end

      if regexp.present? and value.present? and (regexp.match value).blank?
        errors.add(name.to_sym, "is invalid.") 
      end

    end
  end


  # def get_model name
  #   model_id = Neo4j::Session.query('match (n:Model{name: "#{name}"}) RETURN ID(n)')
  #   Neo4j::Node.load(model_id)
  # end
end