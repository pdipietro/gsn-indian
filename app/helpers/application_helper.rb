module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "GSN"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def generate_fields(name, cardinality, type)   
      field_name = "user_identity[#{add_underscore(name)}]"
      prompt_name = "Select #{name.humanize}"
      required_field = is_required_fields? cardinality

      if name=='country'   
        get_select_tag(field_name, country_list, false, prompt_name)    
      elsif name=="default language"       
        get_select_tag(field_name, language_list, false, prompt_name)  
      elsif name=="other languages"
        get_select_tag(field_name, language_list, true, prompt_name)
      else
        text_field_tag field_name, "", autofocus: true, class: "form-control", placeholder: name.humanize, required: required_field
      end

  end
   
   def privacy_tags
   	privacy_data = Neo4j::Session.query(label: :Model, where: 'n.name = "privacy"').data
   	if privacy_data.present?
   		Neo4j::Session.query("start n=node( 150 ) match (n)-[:_HAS_CONSTRAINT]->(m)-[:_HAS_ENUM]->(p) return p.tag, ID(p);").data
   	else
   		[]
   	end

   end

   def add_underscore(str)
    str.downcase.tr(" ", "_")
   end

   def get_select_tag(name, collection_list, multiple, prompt_name)
      select_tag name, options_for_select(collection_list), multiple: multiple, prompt: prompt_name, class: "form-control"
   end

   def country_list
     Neo4j::Session.query('MATCH (n:Model{name: "country"})-[:_HAS_CONSTRAINT]->(constraint)-[:_HAS_ENUM]->(list)--(des) return des.text').data.flatten.compact
   end

   def language_list
     Neo4j::Session.query('MATCH (n:Model{name: "language"})-[:_HAS_CONSTRAINT]->(constraint)-[:_HAS_ENUM]->(list)--(des) return des.text').data.flatten.compact
   end

   def is_required_fields? cardinality
    ['1', '[1::*]'].include?cardinality
   end

   
end


