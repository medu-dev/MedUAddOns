var questionDialog;
var questionId = "";


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
  var value = $("#questionBody").val();

  if(value == undefined || value.trim().length == 0)  {
    alert("Please enter a value");
  }
  var url = "add_question";
  if(currentQuestionMode.isEdit()) {
    url = "edit_question";
  }

  hideQuestionDialog();
  showProgressDialog("Updating questions...");

  $.ajax({
    url: url,
    dataType: 'json',
    type: "POST",
    data:  {
      question: value.trim(),
      question_id: questionId
    },
    success: function(data, status, xhr) {
      if(hasErrors(data))
        return false;

      hideProgressDialog();
      fillQuestionList(data.message);
    },
    error: function(xhr, status, error) {
      showMsg(error);
    }
  });

}

function clearQuestion() {
  $("#questionBody").val("");
}

function setQuestion(question) {
  $("#questionBody").val(question);
}

function setQuestionId(id) {
  questionId = id;
}

function clearQuestionId() {
  questionId = "";
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

function setTitle(value) {

  var dialogOpts = {
    title: value
  };
  $("#questionDlg").dialog(dialogOpts);
}
