/**
 * A random graph is generated and stored in the "graph" variable, and then sigma is
 * instanciated directly with the graph.
 *
 * The simple instanciation of sigma is enough to make it render the graph
 * on the screen, since the graph is given directly to the constructor.
 */

 // graph_data = JSON.parse('<%#= raw [@users.to_json][0] %>')

// Add a method to the graph model that returns an
  // object with every neighbors of a node inside:

  // sigma.classes.graph.addMethod('neighbors', function(nodeId) {
  //   var k,
  //       neighbors = {},
  //       index = this.allNeighborsIndex[nodeId] || {};

  //   for (k in index)
  //     neighbors[k] = this.nodesIndex[k];

  //   return neighbors;
  // });

var load_graph = function(graph_data, node_ids){

sigma.utils.pkg('sigma.canvas.nodes');
sigma.canvas.nodes.image = (function() {
  var _cache = {},
      _loading = {},
      _callbacks = {};

  // Return the renderer itself:
  var renderer = function(node, context, settings) {
    var args = arguments,
        prefix = settings('prefix') || '',
        size = node[prefix + 'size'],
        color = node.color || settings('defaultNodeColor'),
        url = node.url;

    if (_cache[url]) {
      context.save();

      // Draw the clipping disc:
      context.beginPath();
      context.arc(
        node[prefix + 'x'],
        node[prefix + 'y'],
        node[prefix + 'size'],
        0,
        Math.PI * 2,
        true
      );
      context.closePath();
      context.clip();

      // Draw the image
      context.drawImage(
        _cache[url],
        node[prefix + 'x'] - size,
        node[prefix + 'y'] - size,
        2 * size,
        2 * size
      );

      // Quit the "clipping mode":
      context.restore();

      // Draw the border:
      context.beginPath();
      context.arc(
        node[prefix + 'x'],
        node[prefix + 'y'],
        node[prefix + 'size'],
        0,
        Math.PI * 2,
        true
      );
      context.lineWidth = size / 5;
      context.strokeStyle = node.color || settings('defaultNodeColor');
      context.stroke();
    } else {
      sigma.canvas.nodes.image.cache(url);
      sigma.canvas.nodes.def.apply(
        sigma.canvas.nodes,
        args
      );
    }
  };

  // Let's add a public method to cache images, to make it possible to
  // preload images before the initial rendering:
  renderer.cache = function(url, callback) {
    if (callback)
      _callbacks[url] = callback;

    if (_loading[url])
      return;

    var img = new Image();

    img.onload = function() {
      _loading[url] = false;
      _cache[url] = img;

      if (_callbacks[url]) {
        _callbacks[url].call(this, img);
        delete _callbacks[url];
      }
    };

    _loading[url] = true;
    img.src = url;
  };

  return renderer;
})();





  
sigma.renderers.def = sigma.renderers.canvas


// Then, wait for all images to be loaded before instanciating sigma:
// 
var loaded = 0, urls = [] ;  

$.each(graph_data.nodes, function(key, value){
    urls.push(value.url)
  });

urls = urls.filter(function(elem, pos) {
    return urls.indexOf(elem) == pos;
});

urls.forEach(function(url) {
  sigma.canvas.nodes.image.cache( url, function() {

      if (++loaded === urls.length){
      
        // Instanciate sigma:
        s = new sigma({
          graph: graph_data,
          renderer: {
            // IMPORTANT:
            // This works only with the canvas renderer, so the
            // renderer type set as "canvas" is necessary here.
            container: document.getElementById('graph-container'),
            type: 'canvas'
          },
          settings: {
            minNodeSize: 8,
            maxNodeSize: 16,
          }
        });   

       
    

        // Initialize the dragNodes plugin:
        sigma.plugins.dragNodes(s, s.renderers[0]);
        
        // Bind the events:        
        double_click_node_event(s)
        click_node_event(s)

      }
    });


});





}



var double_click_node_event = function(s){
  s.bind('doubleClickNode', function(e) { 
        // s.bind('overNode', function(e) { 
         //  var attr_node = ""
         //  var attr_edge = ""
         //  var edge_property = e.data.node.properties.edge
         //  var inc = 0;
          
         //  if(edge_property.relation_id != undefined) {
         //    edge_prop = ''
         //    $.each(edge_property.relation_id, function(key, relation_id) {     
         //       edge_prop += relation_html(key, relation_id, edge_property.relation_name[inc])
         //       inc++
         //     });
         //    $("#edge_prop_tooltip").attr('data-original-title', edge_prop)
         // }

         //   if(e.data.node.properties.edge != undefined) {
         //     $.each(e.data.node.properties.edge, function(k, v) {
         //      attr_edge += "<li><span style='color:red; margin-right: 20px;'>"+k+":</span><span>"+v+"</span></li>"
         //    });
         //   }

         //  label = e.data.node.label.split(' ')[0]
         //   switch(label){
         //    case 'User': 
         //       attr_node = get_user_data(e, attr_node)
         //      break; 
         //    case 'UserIdentity':
         //       attr_node = get_user_identity_data(e, attr_node) 
         //       break; 
         //    case 'Provider': 
         //      attr_node = get_provider_data(e, attr_node)
         //      break; 
         //    case 'Group': 
         //      attr_node = get_group_data(e, attr_node)
         //      break; 
         //    case 'GroupType': 
         //      attr_node = get_group_type_data(e, attr_node)
         //       break; 
         //    case 'NodeType': 
         //      attr_node = get_node_type_data(e, attr_node)
         //      break; 
         //    case 'NodeAttribute': 
         //      attr_node = get_node_attribute_data(e, attr_node)
         //      break; 
         //  }

         //  $("#myModalLabel").html(e.data.node.label);
         //  $("#modal_body_content").html(attr_node);
         //  $("#nodeModal").modal("show");

          $.ajax({
            type: "GET",
            url: "/users/"+ e.data.node.id +"/show_other_node?node_ids="+node_ids
              
          }).done(function(data) {            
           
            data[0].nodes.forEach(function(n){
              s.graph.addNode(n)
            });

            data[0].edges.forEach(function(e){
              s.graph.addEdge(e)
            });

            data[1].forEach(function(d){
              if ($.inArray(d, node_ids) == -1)
              {
                node_ids.push(d)
              }
              
            });
          s.refresh();

        });
          s.refresh();
          
        });
}


var get_node_ele = function(){
  first_node=$("#selected_first_node")
  second_node=$("#selected_second_node")
  first_node_id = first_node.attr('data-id')
  second_node_id = second_node.attr('data-id')
}

var click_node_event = function(s){
  s.bind('clickNode', function(e) {  
          
          $("#selected_node_container").show();
          get_node_ele();
          selected_node = e.data.node
          console.log(e)
          console.log(e.data)

          if(first_node_id==""){
            set_selected_node(e, first_node, selected_node, "Start node")
            // show_attributes(e);
          }
          else{
            set_selected_node(e, second_node, selected_node, "End node")
          }

          if(first_node_id == "" && second_node_id == ""){
            $("#add_relation_node").hide();
           } 
          else
          {
            $("#add_relation_node").show();
          }
          
          
        //   $.ajax({
        //     type: "GET",
        //     url: "/users/"+ e.data.node.id +"/show_other_node?node_ids="+node_ids
              
        //   }).done(function(data) {            
           
        //     data[0].nodes.forEach(function(n){
        //       s.graph.addNode(n)
        //     });

        //     data[0].edges.forEach(function(e){
        //       s.graph.addEdge(e)
        //     });

        //     data[1].forEach(function(d){
        //       if ($.inArray(d, node_ids) == -1)
        //       {
        //         node_ids.push(d)
        //       }
              
        //     });
        //   s.refresh();

        // });
        //   s.refresh();

        });
}


$(document).on("click", "#reset_node", function() {
  get_node_ele();
  first_node.attr('data-id', '');
  first_node.text('');
  second_node.attr('data-id', '');
  second_node.text('');
  $("#add_relation_node").hide();
});

$(document).on("click", "#add_relation_node", function() {
   get_node_ele();
   if(first_node_id == second_node_id){
     alert("Start and End node will not be same")
   }
   else{   

     $("#start_node_modal").val(first_node_id);
     $("#end_node_modal").val(second_node_id);
     $("#relationModal").modal("show");

   }
  // $("#add_relation_node")
});

var show_attributes = function(e){
  var attr_node = "<h4>Attributes</h4>"
  label = e.data.node.label.split(' ')[0]
     switch(label){
      case 'User': 
         attr_node = get_user_data(e, attr_node)
        break; 
      case 'UserIdentity':
         attr_node = get_user_identity_data(e, attr_node) 
         break; 
      case 'Provider': 
        attr_node = get_provider_data(e, attr_node)
        break; 
      case 'Group': 
        attr_node = get_group_data(e, attr_node)
        break; 
      case 'GroupType': 
        attr_node = get_group_type_data(e, attr_node)
         break; 
      case 'NodeType': 
        attr_node = get_node_type_data(e, attr_node)
        break; 
      case 'NodeAttribute': 
        attr_node = get_node_attribute_data(e, attr_node)
        break; 
      default:
        attr_node = get_all_data(e, attr_node)
    }
    return attr_node;
}


var set_selected_node = function(node, node_ele, selected_node, node_pos){
  node_ele.text(node_pos + ": " + selected_node.label)
  node_ele.attr('data-id', selected_node.id)
  html= "<ul><h4>" + node_pos + ": " + selected_node.label + "</h4><li>"+ show_attributes(node) +"</li></ul>"
  console.log(html)
  node_ele.html(html)
}

var get_all_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    attr_node += node_html(k, v)
    node_prop += node_html(k, v)
  }); 
  $("#node_prop_tooltip").attr('data-original-title', node_prop)
  return attr_node; 
}

var get_user_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {    
    if(k =='first_name' || k=='last_name' || k=='country') {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  }); 
  $("#node_prop_tooltip").attr('data-original-title', node_prop)
  return attr_node; 
}

var get_user_identity_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    if(k=='email' || k=='nickname' || k=='country') {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  });
  $("#node_prop_tooltip").attr('data-original-title', node_prop) 
  return attr_node;  
}

var get_provider_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    if(k=='provider_name') {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  }); 
  $("#node_prop_tooltip").attr('data-original-title', node_prop)
  return attr_node;  
}

var get_group_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    if(k!='created_at' && k!='updated_at' && k!='color' && k!='uuid' && k!='id' ) {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  }); 
  $("#node_prop_tooltip").attr('data-original-title', node_prop)
  return attr_node;  
}

var get_group_type_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    // if(k=='provider_name') {
      attr_node += node_html(k, v)
    // }
  }); 
  $("#node_prop_tooltip").attr('data-original-title', attr_node)
  return attr_node;  
}

var get_node_type_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    if(k=='field_name') {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  }); 
  $("#node_prop_tooltip").attr('data-original-title', node_prop)
  return attr_node;  
}

var get_node_attribute_data = function(e, attr_node){
  node_prop = ''
  $.each(e.data.node.properties.node, function(k, v) {
    if(k=='name' ||  k=="attr_type") {
      attr_node += node_html(k, v)
    }
    node_prop += node_html(k, v)
  }); 
  $("#node_prop_tooltip").attr('data-original-title', node_prop)
  return attr_node;  
}


var node_html = function(property, value){
 return "<li><span style='color:red; margin-right: 20px;'>"+capitalize_str(property)
+":</span><span>"+value+"</span></li>"
}

var relation_html = function(key, relation_id, relation_name){
 return "<li><span style='color:red; margin-right: 20px;'>"+capitalize_str(relation_id)
+":</span><span>"+relation_name+"</span></li>"

}


var capitalize_str = function(str){
  str = str.toLowerCase().replace("_", " ").replace(/\b[a-z]/g, 
  function(letter) {
    return letter.toUpperCase();
  });
  return str;
} 
