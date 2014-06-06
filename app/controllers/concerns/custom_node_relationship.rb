module CustomNodeRelationship

	 extend ActiveSupport::Concern

	 def create_node(options = {})	 
        node     = options[:node]
        relation = options[:relation]
        label    = options[:label]
        color    = options[:color]
        image_url = "/assets/icon/crowdup/#{label.try(:downcase)}.png"        
        check_url =  "#{Rails.root}/app/assets/images/icon/crowdup/#{label.try(:downcase)}.png"     

        check_file = File.exist?(check_url)        
        default_url = check_file ? image_url : "/assets/img/img3.png"        
        # url    = options[:url].present? ? options[:url] : default_url
        url    = default_url
        relation_name = []
        relation_id = []
        node.rels.each do |rel|
          relation_name << rel.load_resource['type']
          relation_id <<  "Relation #{rel.neo_id}"
        end
        label_html = "#{label}"
	 	    {
       	           id:         node.neo_id.to_s,  
       	           label:      label_html, 
       	           x:          Random.rand(1-6664664646),
       	           y:          Random.rand(1-6664664646),
       	           size:       Random.rand(1-6664664646),
       	           color:      "#C0C0C0",
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



end