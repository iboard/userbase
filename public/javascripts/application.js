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
 
 $(to).load('/posting_preview/?text='+escape(t));
}
