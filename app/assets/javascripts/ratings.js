var currentCardid = "";
var currentUserId = "";

function getRating(id, question_id) {
  var score = $("#"+id).val();

  $.ajax({
    url: "save_answer",
    type: "POST",
    dataType: 'json',
    data:  {
      score: score,
      cardid: currentCardid,
      userid: currentUserId,
      questionid: question_id
    },
    success: function(data, status, xhr) {
      hasErrorsDebug(data);
      return;
    },
    error: function(xhr, status, error) {
      showMsgDebug(error);
      return;
    }
  });

}