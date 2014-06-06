
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

end