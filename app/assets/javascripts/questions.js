function createQuestionDialog() {

   questionDialog = $("#questionDlg")
      .dialog({
        autoOpen: false,
        modal: true,
        show: true,
        hide: true,
        width: 400,
        title: "Add a question",
        buttons: { "Save": doValidate , "Cancel": function() { $(this).dialog("close"); } }
      });
}

var doValidate = function () {
//  if (validateContact()) {
//    $("#contactDlg").dialog("close");
//    submitContact();
//  }
//  else return false ;
}

function showQuestionDialog() {
  if(questionDialog != null) {
    $('#questionDlg').dialog('open');
  }
}

function hideQuestionDialog() {
  if(questionDialog != null) {
    $('#questionDlg').dialog('close');
  }
}
