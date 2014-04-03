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
//= require jquery.minicolors  

$(document).ready(function(){
    $('#node_color_field').minicolors()
})             

