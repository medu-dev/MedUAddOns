var cardDialog;

function createCardDialog() {

  cardDialog = $("#cardDlg")
      .dialog({
        autoOpen: false,
        modal: true,
        show: true,
        hide: true,
        width: 300,
        title: "Add a card id",
        buttons: { "Save": doValidateCard , "Cancel": function() { $(this).dialog("close"); } }
      });
}

var doValidateCard = function () {
  var value = $("#cardBody").val();

  if(value == undefined || value.trim().length == 0)  {
    alert("Please enter a value");
    return false;
  }

  if(isNaN(value.trim())) {
    alert("Please enter a number");
    return false
  }

  hideCardDialog();
  showProgressDialog("Adding card...");

  $.ajax({
    url: "add_relation",
    dataType: 'json',
    type: "POST",
    data:  {
      card_id: value.trim(),
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

function clearCard() {
  $("#cardBody").val("");
}

function showCardDialog() {
  if(cardDialog != null) {
    $('#cardDlg').dialog('open');
  }
}

function hideCardDialog() {
  if(cardDialog != null) {
    $('#cardDlg').dialog('close');
  }
}

