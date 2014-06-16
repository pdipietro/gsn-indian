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

        node.rels.each do |rel|
          relation_name << rel.load_resource['type']
          relation_id <<  "Relation #{rel.neo_id}"
        end

        label_html = prop_name.present? ? "#{prop_name.try(:humanize)}" : "#{label}"
       
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
       	           	edge:         {
                        relation_name: relation_name,
                        relation_id: relation_id
                    }
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



end