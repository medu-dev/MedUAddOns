var currentCardid = "";
var currentUserId = "";
var currentCourseId = "";

function getRating(id, question_id) {
  var score = $("#"+id).val();

  $.ajax({
    url: "save_answer",
    type: "POST",
    dataType: 'json',
    data:  {
      score: score,
      cardid: currentCardid,
      courseid: currentCourseId,
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