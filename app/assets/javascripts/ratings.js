var currentCardid = "";
var currentUserId = "";
var currentCourseId = "";
var currentCaseName = "";
var currentCaseId = "";
var currentCardName = "";
var currentGroupId = "";

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
      casename: encodeURIComponent(currentCaseName),
      caseid: currentCaseId,
      cardname: encodeURIComponent(currentCardName),
      groupid: currentGroupId,
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