// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require src/sigma.core.js                                
//= require src/conrad.js                                    
//= require src/utils/sigma.utils.js                         
//= require src/utils/sigma.polyfills.js                     
//= require src/sigma.settings.js                            
//= require src/classes/sigma.classes.dispatcher.js          
//= require src/classes/sigma.classes.configurable.js        
//= require src/classes/sigma.classes.graph.js               
//= require src/classes/sigma.classes.camera.js              
//= require src/classes/sigma.classes.quad.js                
//= require src/captors/sigma.captors.mouse.js               
//= require src/captors/sigma.captors.touch.js               
//= require src/renderers/sigma.renderers.canvas.js          
//= require src/renderers/sigma.renderers.webgl.js           
//= require src/renderers/sigma.renderers.def.js             
//= require src/renderers/webgl/sigma.webgl.nodes.def.js     
//= require src/renderers/webgl/sigma.webgl.nodes.fast.js    
//= require src/renderers/webgl/sigma.webgl.edges.def.js     
//= require src/renderers/webgl/sigma.webgl.edges.fast.js    
//= require src/renderers/webgl/sigma.webgl.edges.arrow.js   
//= require src/renderers/canvas/sigma.canvas.labels.def.js  
//= require src/renderers/canvas/sigma.canvas.hovers.def.js  
//= require src/renderers/canvas/sigma.canvas.nodes.def.js   
//= require src/renderers/canvas/sigma.canvas.edges.def.js   
//= require src/renderers/canvas/sigma.canvas.edges.arrow.js 
//= require src/renderers/canvas/sigma.canvas.edges.curve.js 
//= require src/middlewares/sigma.middlewares.rescale.js     
//= require src/middlewares/sigma.middlewares.copy.js        
//= require src/misc/sigma.misc.animation.js                 
//= require src/misc/sigma.misc.bindEvents.js                
//= require src/misc/sigma.misc.drawHovers.js 
//= require plugins/sigma.plugins.dragNodes/sigma.plugins.dragNodes.js 
//= require plugins/sigma.renderers.customShapes/shape-library.js
//= require plugins/sigma.renderers.customShapes/sigma.renderers.customShapes.js
//= require jquery.minicolors  
//= require graph  

$(document).ready(function(){
    $('#node_color_field').minicolors();
    $("a[rel='tooltip']").tooltip({'placement': 'right', 'z-index': '3000'});
    
    $(document).on("click", "#header_profile_link", function() {
    	$("#profileModal").modal("show");
    });

    $(".dropdown-menu > li > a.trigger").on("click",function(e){
		var current=$(this).next();
		var grandparent=$(this).parent().parent();
		if($(this).hasClass('left-caret')||$(this).hasClass('right-caret'))
			$(this).toggleClass('right-caret left-caret');
		grandparent.find('.left-caret').not(this).toggleClass('right-caret left-caret');
		grandparent.find(".sub-menu:visible").not(current).hide();
		current.toggle();
		e.stopPropagation();
	});
	$(".dropdown-menu > li > a:not(.trigger)").on("click",function(){
		var root=$(this).closest('.dropdown');
		root.find('.left-caret').toggleClass('right-caret left-caret');
		root.find('.sub-menu:visible').hide();
	});
});




         

