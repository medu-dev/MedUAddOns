// Creates an iframe and adds it to a div. Expects a div with the id "card_questions".
// this could be generalized to accept parameters for the div id and iframe properties

//$(document).ready(function(){
jQuery(document).ready(function ($) {
  addIFrame();
});

function addIFrame() {
  var iframe = createIFrame();

  if(iframe != undefined && iframe != false) {
    var div = document.getElementById("card_questions");
    div.appendChild(iframe);
  }
}

function createIFrame() {
  try {
    var element = document.createElement('iframe');
    element.id= "cq1";
    element.allowtransparency="true";
    element.frameborder="0";
    element.style.width = "100%";
    element.style.border = "none";
    element.style.overflow = "hidden";
    element.style.height = "200px";
    element.src="http://<<HOSTNAME>>" +
        "/card_questions/show?cardid=<<CARDID>>&userid=<<USERID>>&courseid=<<COURSEID>>" +
        "&casename=<<CASENAME>>&caseid=<<CASEID>>&cardname=<<CARDNAME>>&groupid=<<GROUPID>>";
    element.scrolling="no";
    element.horizontalscrolling="no";
    element.verticalscrolling="no";

    return element;
  }
  catch (err) {
//    alert(err);
    return false;
  }
}