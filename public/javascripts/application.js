// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/* PROTOTYPE 
function add_fields(link,association,content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_"+association,"g")
    $(link).up().insert({
        before: content.replace(regexp, new_id)
    });
} */

/* PROTOTYPE
function remove_fields(link) {
    $(link).previous("input[type=hidden]").value = "1";
    $(link).up(".fields").hide();
} */

/* *******************************************************
/* jQUERY 
******************************************************* */
function add_fields(link, association, content) {  
    var new_id = new Date().getTime();  
    var regexp = new RegExp("new_" + association, "g");  
    $(link).parent().before(content.replace(regexp, new_id));  
}

function remove_fields(link) {  
    $(link).prev("input[type=hidden]").val("1");  
    $(link).closest(".fields").hide();  
}  
  
function initialize_hud(label,txt) {
    $('#HUDCONTAINER').html( 
       "<div id='HUD'>"+
         "<div class='centered_spinner'>"+
           "<img src=/images/spinner.gif border=0><br/><br/>"+txt+
         "</div>"+
       "</div>"+
       "<br/><span style='color:white; heigth: 30px; padding: 10px; font-size: 10px;'>"+
         "<a style='color: white;' href='#' onclick='Element.fade(\"HUDCONTAINER\",{duration:0.5});'>"+label+"</a>"+
       "</span>");
    Element.fadeShow();
}

function initialize_loading(update,txt) {
    $(update).html("<img src='/images/spinner.gif'><br/>"+txt)
}

function rerender(from_field,to) {
 var t = $(from_field).val();
 
 /* convert on client-side with textile.js */
 $(to).html( convert(t));
 
 /* or convert on server-side with ajax */
 /* $(to).load('/posting_preview/?text='+escape(t)); */
}

function set_page_opacity(v,d) {
  $('header').fadeTo( d, v );
  $('#page_section').fadeTo( d, v );
  $('#right_sidebar').fadeTo( d, v );
}

function close_popup() {
  $('#overlay').fadeOut('slow');
  $('#overlay').html("<!--hidden-->");
  set_page_opacity(1.0,1000);
}

function image_popup(img_url) {
  var new_id = new Date().getTime(); 
  var regexp = new RegExp("popup", "g");  
  
  set_page_opacity(0.2,1500);
  
  $('#overlay').html( 
       "<div class='close_icon'>"+
         "<a href='#' onclick='close_popup();return false;'>"+
           "<img src='/images/close.gif?"+new_id+"'>"+
         "</a>"+
       "</div>"+
       "<div id='overlay_content' class='overlay_content'>"+
          "<a href='#' onclick='close_popup();return false;'>"+
          "<img src='"+img_url+"'>"+
          "</a><br/><a href='"+img_url.replace(regexp,'original')+"'>Download</a>"+
      "</div>"
      );
  $('#overlay').fadeTo(500,1.0);  
}

function video_popup(img_url,mobile_url) {
  var new_id = new Date().getTime(); 
  var regexp = new RegExp("popup", "g");  
  
  set_page_opacity(0.2,1500);
  
  $('#overlay').html( 
       "<div class='close_icon'>"+
         "<a href='#' onclick='close_popup();return false;'>"+
          "<img src='/images/close.gif?"+new_id+"'>"+
         "</a>"+
       "</div>" +
       "<div style='margin-top: 80px; vertical-align: baseline;'>"+
         "<video controls autoplay width=\"640\" height=\"400\" "+
                 " src=\""+img_url+"\""+
                 " type='video/mp4'"+
            ">" +
              "Your browser does not support the video tag."+
            "</video>"+"</div>"+
      "</div>"+       
      "<center>"+
        "<a href='"+img_url+"'>"+img_url+"</a>"+"<br/>"+
        "<a href='"+mobile_url+"'>"+mobile_url+"</a>"+
      "</center>" 
    );
  $('#overlay').fadeTo(500,1.0);  
}

function youtube_popup(img_url) {
  var new_id = new Date().getTime(); 
  var regexp = new RegExp("popup", "g");  
  
  set_page_opacity(0.2,1500);
  
  $('#overlay').html( 
       "<div class='close_icon'>"+
         "<a href='#' onclick='close_popup();return false;'>"+
          "<img src='/images/close.gif?"+new_id+"'>"+
         "</a>"+
       "</div>" +
       "<div style='margin-top: 80px; vertical-align: baseline;'>"+
         "<object width='640' height='480'><param name='movie' value='"+img_url+
         "?fs=1&amp;hl=en_US&amp;rel=0&amp;color1=0x2b405b&amp;color2=0x6b8ab6'>"+
         "</param><param name='allowFullScreen' value='true'></param>"+
         "<param name='allowscriptaccess' value='always'></param><embed src='"+img_url+
         "?fs=1&amp;hl=en_US&amp;rel=0&amp;color1=0x2b405b&amp;color2=0x6b8ab6' "+
         "type='application/x-shockwave-flash' allowscriptaccess='always' "+
         "allowfullscreen='true' width='640' height='480'></embed></object>"+
       "</div>"+
       "<center><a href='"+img_url+"'>YouTube: "+img_url+"</a></center>" 
       );
  $('#overlay').fadeTo(500,1.0);  
}