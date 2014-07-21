module CustomNodeRelationship

   extend ActiveSupport::Concern

   def create_node(options = {})   
        node     = options[:node]
        relation = options[:relation]
        label    = options[:label]
        color    = options[:color].present? ? options[:color] : "#C0C0C0"
        image_url = "/assets/icon/crowdup/#{label.try(:downcase)}.png"        
        check_url =  "#{Rails.root}/app/assets/images/icon/crowdup/#{label.try(:downcase)}.png"  
        prop_name = word_underscore(node.props[:name])
      
        if label.to_s=="Metamodel"
          image_url = "/assets/icon/metamodel_img/mm.#{prop_name}.png"
          check_url =  "#{Rails.root}/app/assets/images/icon/metamodel_img/mm.#{prop_name}.png"
        else
          image_url = "/assets/icon/crowdup/#{label.try(:downcase)}.png"
          check_url =  "#{Rails.root}/app/assets/images/icon/crowdup/#{label.try(:downcase)}.png"
        end

        check_file = File.exist?(check_url)        
        default_url = check_file ? image_url : "/assets/img/is_missing.png" 
         
        # url    = options[:url].present? ? options[:url] : default_url
        url    = default_url
        relation_name = []
        relation_id = []
        relation_info = []
         # Rails.logger.debug node.inspect
         # Rails.logger.debug "LLLLLLLLLLLLLLLLLLL START NODE START NODE"
        # node.rels.each do |rel|
        #   relation_type = rel.load_resource['type']
        #   # binding.pry
        #   # Rails.logger.debug rel.inspect
        #   # Rails.logger.debug rel.neo_id
        #   # Rails.logger.debug "::::::::::::::::::::::::::::::::::::::::"
        #   # Rails.logger.debug "(#{rel.start_node.labels[0]}) -> [#{relation_type}] -> (#{rel.end_node.labels[0]})"
        #   relation_info << "(#{rel.start_node.labels[0]}) -> [#{relation_type}] -> (#{rel.end_node.labels[0]})"          
         
        # end

        rel_start_node =[]
        rel_end_node =[]
        relation_arr =[]
        count_rel = {}

        node.rels.each do |rel|
          relation_type = rel.load_resource['type']         
          # binding.pry
          if rel._start_node.neo_id == node.neo_id 
            relation_hash_name = "me - #{relation_type} #right_arrow#"
          else
            relation_hash_name = "me #left_arrow# #{relation_type} -"
          end
          count_rel[relation_hash_name] = (count_rel[relation_hash_name].blank?) ? 1 : (count_rel[relation_hash_name] += 1)
        end

        count_rel.each do |rel, count|
                relation_info << "#{rel} x#{count}"
        end
        
    #     Rails.logger.debug relation_info.inspect
    #     Rails.logger.debug count_rel.inspect
    #     Rails.logger.debug "END END END END END"
				# Rails.logger.debug "**********************************************"

        label_html = prop_name.present? ? "#{prop_name.try(:humanize)}" : "#{label}"
        label_html = "#{label_html} [#{node.neo_id}]"
        {
                   id:         node.neo_id.to_s,  
                   label:      label_html, 
                   x:          Random.rand(1-6664664646),
                   y:          Random.rand(1-6664664646),
                   size:       Random.rand(1-6664664646),
                   color:      color,
                   type:       "image",
                   url:        url,
                   properties: {
                    node:         node.props,
                    edge:         relation_info
                               },
                   relation:   relation
        }

   end

   def create_edge(options = {})
      source           = options[:source]
      target           = options[:target]
      relation         = options[:relation]
      color            = options[:color]         
      relation_name    = options[:relation_name].try(:capitalize) 
      {
            id: "#{relation.neo_id}",
            source: source.neo_id.to_s,
            target: target.neo_id.to_s,
            size:   1000,
            color:  color,
            type: "arrow",
            relation_name: relation_name
      }
   end

  def word_underscore(word)
    word.gsub(" ", '_').downcase  if word.present?
    # word.scan(/[A-Z][a-z]*/).join("_").downcase if word.present?
  end

 def check_node_label(node)
   !(node.labels[0].blank? and node.neo_id.to_i <=1000)
 end

  def get_relation_data(node, data_collections, relations, check_end_node, check_node=[] )
    relations.each do |relation|

       edge_resource = relation.load_resource
       e_node = relation._end_node
       e_node_id = relation._end_node.neo_id
       e_node_label = e_node.labels[0]
       s_node = relation._start_node
       s_node_id = relation._start_node.neo_id
       s_node_label = s_node.labels[0]
       edge_properties = relation.props
       edge_relation = edge_resource.present? ? edge_resource["type"] : ""
       color_prop = relation._end_node.props[:color].present? ? relation._end_node.props[:color] : '#666'
#       if s_node_label.present? and check_node_label(s_node)
         unless check_end_node.include? e_node_id
           check_end_node << e_node_id
           data_collections[:nodes] << create_node(node: e_node, relation: edge_relation, label: e_node.labels[0].to_s, color: color_prop)
   
         end 
#       end

       data_collections[:edges] << create_edge(source: s_node, target: e_node, relation: relation, color: '#ccc', relation_name: edge_relation)
    end
  
  end

  def get_relation_data_incoming(node, data_collections, relations, check_end_node, check_node)
    relations.each do |relation|

       edge_resource = relation.load_resource
       e_node = relation._end_node
       e_node_id = relation._end_node.neo_id
       e_node_label = e_node.labels[0]
       s_node = relation._start_node
       s_node_id = relation._start_node.neo_id
       s_node_label = s_node.labels[0]
       edge_properties = relation.props
       edge_relation = edge_resource.present? ? edge_resource["type"] : ""
       color_prop = relation._end_node.props[:color].present? ? relation._end_node.props[:color] : '#666'

#       if s_node_label.present? and check_node_label(s_node)
           unless check_end_node.include? s_node_id
             check_end_node << s_node_id
             @data_collections[:nodes] << create_node(node: s_node, relation: edge_relation, label: s_node_label, color: color_prop, url: "/assets/img/img3.png")
            
           end
           @data_collections[:edges] << create_edge(source: s_node, target: e_node, relation: relation, color: '#ccc', relation_name: edge_relation)
#        end
    end  
  end

 

  


end
