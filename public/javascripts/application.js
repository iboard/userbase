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

function set_page_opacity(v) {
  $('#page_section').css('opacity', v);
  $('header').css('opacity', v);
  $('#right_sidebar').css('opacity', v);
}

function close_popup() {
  $('#overlay').fadeOut('fast');
  set_page_opacity(1.0);
}

function image_popup(img_url) {
  set_page_opacity(0.5);
  $('#overlay').html( "<div class='close_icon'><a href='#' onclick='close_popup();return false;'><img src='/images/close.gif'></a></div>"+
        "<div id='overlay_content'><a href='#' onclick='close_popup();return false;'><img src='"+img_url+"'></a></div>");
  $('#overlay').fadeIn('fast');
}