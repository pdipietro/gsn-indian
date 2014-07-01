;(function(undefined) {
  'use strict';

  if (typeof sigma === 'undefined')
    throw 'sigma is not declared';

  // Initialize packages:
  sigma.utils.pkg('sigma.canvas.hovers');

  /**
   * This hover renderer will basically display the label with a background.
   *
   * @param  {object}                   node     The node object.
   * @param  {CanvasRenderingContext2D} context  The canvas context.
   * @param  {configurable}             settings The settings function.
   */
  sigma.canvas.hovers.def = function(node, context, settings) {
    var x,
        y,
        w,
        h,
        e,
        fontStyle = settings('hoverFontStyle') || settings('fontStyle'),
        prefix = settings('prefix') || '',
        size = node[prefix + 'size'],
        fontSize = (settings('labelSize') === 'fixed') ?
          settings('defaultLabelSize') :
          settings('labelSizeRatio') * size;
    
     // Node properties
     var node_prop = ''
      $.each(node.properties.node, function(property, value) {   
        node_prop += '<li><span style="color:red; margin-right: 20px; list-style: none">'+(property)+
        ':</span><span>'+value+'</span></li>'
      });

      var edge_prop = ''
     
       $.each(node.properties.edge, function(property, value) {  
      
        value = value.replace(/#right_arrow#/g, "→");
        value = value.replace(/#left_arrow#/g, "←");
       
        edge_prop += '<li>'+value+'</li>'
        
        // edge_prop += '<li><span style="color:red; margin-right: 20px; list-style: none">'+(property)+
        // ':</span><span>'+value+'</span></li>'
      });

    // Label background:
    context.font = (fontStyle ? fontStyle + ' ' : '') +
      fontSize + 'px ' + (settings('hoverFont') || settings('font'));

    context.beginPath();
    context.fillStyle = settings('labelHoverBGColor') === 'node' ?
      (node.color || settings('defaultNodeColor')) :
      settings('defaultHoverLabelBGColor');

    if (settings('labelHoverShadow')) {
      context.shadowOffsetX = 0;
      context.shadowOffsetY = 0;
      context.shadowBlur = 8;
      context.shadowColor = settings('labelHoverShadowColor');
    }

    if (typeof node.label === 'string') {
      x = Math.round(node[prefix + 'x'] - fontSize / 2 - 2);
      y = Math.round(node[prefix + 'y'] - fontSize / 2 - 2);
      w = Math.round(
        context.measureText(node.label).width + 20 + fontSize / 2 + size + 7
      );
      h = Math.round(100 + fontSize + 4);
      e = Math.round(fontSize / 2 + 2);

      // context.moveTo(x, y + e);
      // context.arcTo(x, y, x + e, y, e);
      // context.lineTo(x + w, y);
      // context.lineTo(x + w, y + h);
      // context.lineTo(x + e, y + h);
      // context.arcTo(x, y + h, x, y + h - e, e);
      // context.lineTo(x, y + e);

      context.closePath();
      context.fill();

      context.shadowOffsetX = 0;
      context.shadowOffsetY = 0;
      context.shadowBlur = 0;
    }

    // Node border:
    if (settings('borderSize') > 0) {
      context.beginPath();
      context.fillStyle = settings('nodeBorderColor') === 'node' ?
        (node.color || settings('defaultNodeColor')) :
        settings('defaultNodeBorderColor');
      context.arc(
        node[prefix + 'x'],
        node[prefix + 'y'],
        size + settings('borderSize'),
        0,
        Math.PI * 2,
        true
      );
      context.closePath();
      context.fill();
    }

    // Node:
    var nodeRenderer = sigma.canvas.nodes[node.type] || sigma.canvas.nodes.def;
    nodeRenderer(node, context, settings);
      
    // Display the label:
    if (typeof node.label === 'string') {
      context.fillStyle = (settings('labelHoverColor') === 'node') ?
        (node.color || settings('defaultNodeColor')) :
        settings('defaultLabelHoverColor');
      

      // context.fillText(
      //   node.label,
      //   Math.round(node[prefix + 'x'] + size + 3),
      //   Math.round(node[prefix + 'y'] + fontSize / 3)
      // );
    
      // var data   = '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200">' +
      //          // '<image x="200" y="200" width="300" height="80" xlink:href="http://jenkov.com/images/layout/top-bar-logo.png" />' +
      //          '<foreignObject width="100%" height="100%">' +
      //           '<div xmlns="http://www.w3.org/1999/xhtml" style="font-size:12px; background-color: white;">' +
      //           // '<image xlink:href="http://localhost:3000/assets/img/img1.png" height="20px" width="20px"/>'+
      //             '<img src="http://localhost:3000/assets/img/img1.png" height="50" width="50" alt="img1"/>'+
      //             '<span style="color:white; text-shadow:0 0 2px blue;">'+ node.label + '</span>'+
      //             '<div id="modal_body_content" class="span10">'+ node_prop +'</div>'+
      //             '</div>' +
      //          '</foreignObject>' +
      //        '</svg>';

            var data   = '<svg xmlns="http://www.w3.org/2000/svg" width="300" height="500">' +
               // '<image x="200" y="200" width="300" height="80" xlink:href="http://jenkov.com/images/layout/top-bar-logo.png" />' +
               '<foreignObject width="300" height="500">' +
                '<div xmlns="http://www.w3.org/1999/xhtml" style="font-size:12px; background-color: white; border: 1px solid #bbb">' +
                // '<image xlink:href="http://localhost:3000/assets/img/img1.png" height="20px" width="20px"/>'+
                  // '<img src="http://localhost:3000/assets/img/img1.png" height="50" width="50" alt="img1"/>'+
                  '<span style="color:black; font-size: 18px">'+ node.label + '</span>'+
                  '<div id="modal_body_content" class="span10">'+ node_prop +'</div>'+
                  '<span style="color:black; font-size: 14px">Relationships</span>'+
                  '<div class="span10">'+ edge_prop +'</div>'+
                  '</div>' +
               '</foreignObject>' +
             '</svg>';

      // var data   = '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200">' +
      //          '<foreignObject width="100%" height="100%">' +
      //            '<div xmlns="http://www.w3.org/1999/xhtml" style="font-size:40px">' +
      //              '<em>I</em> like <span style="color:white; text-shadow:0 0 2px blue;">cheese</span>' +
      //            '</div>' +
      //          '</foreignObject>' +
      //        '</svg>';
            
     var DOMURL = window.URL || window.webkitURL || window;
     var img = new Image();
     var svg = new Blob([data], {type: 'image/svg+xml;charset=utf-8'});
     var url = DOMURL.createObjectURL(svg);
     img.onload = function () {
      context.drawImage(img, 
        Math.round(node[prefix + 'x'] + size + 3),
        Math.round(node[prefix + 'y'] + fontSize / 3 -12)
      ); 
       
        //  context.drawImage(img.src='/assets/img/img1.png', 
        // Math.round(node[prefix + 'x'] + size + 3),
        // Math.round(node[prefix + 'y'] + fontSize / 3 -12)
        // ); 
         //context.restore(); // exit clipping mode
      DOMURL.revokeObjectURL(url);
    }
    img.src = url; 

        }


    //  context.drawImage(img.src="/assets/img/img1.png", 
    // Math.round(node[prefix + 'x'] + size + 3+10),
    // Math.round(node[prefix + 'y'] + fontSize / 3 -12-10),10,10,10,10,10,10
    // );



  // img.src='/assets/img/img1.png';
  // img.onload = function () {
  // context.drawImage(img,Math.round(node[prefix + 'x'] + size + 3+10),
  //    Math.round(node[prefix + 'y'] + fontSize / 3 -12-10)
  //    ,50,60,10,10,150,60);

  //     }
  };
}).call(this);