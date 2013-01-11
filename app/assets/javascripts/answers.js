function fillAnswersList(answers) {

  var table = document.getElementById("answerTable")

  // Remove all table rows
  var tableRows = table.rows;
  for (var i = tableRows.length-1; i >= 0; i--) {
    table.deleteRow(i);
  }

  if(answers.length == 0)  {
    var r = createTableRow(table, "");
    createTextCell(r, "", "There are no answers. Perhaps thats the trouble with life.", "");
    return;
  }

  var lastQuestionId = "";
  var lastCourseId = "";
  var rowCount = 0;
  var row;

  for(i=0; i < answers.length; i++) {

    if((answers[i].questions_id != lastQuestionId) || (answers[i].course_id != lastCourseId))  {
      var row = createTableRow(table, (rowCount % 2 != 0) ? 'odd':'');
      rowCount++;
      lastQuestionId = answers[i].questions_id;
      lastCourseId = answers[i].course_id;

      createTextCell(row, "", answers[i].body, "");
      createTextCell(row, "", answers[i].course_name, "");
    }

    row = createTableRow(table, (rowCount % 2 != 0) ? 'odd':'');
    rowCount++;
    createTextCell(row, "", "answer: " + answers[i].score, "");
    createTextCell(row, "", "", "");
  }
}

function getAllAnswers() {

  showProgressDialog("Getting answers...");

  $.ajax({
    url: "get_all_answers",
    dataType: 'json',
    success: function(data, status, xhr) {
      if(hasErrors(data))
        return false;

      hideProgressDialog();
      fillAnswersList(data.message);
    },
    error: function(xhr, status, error) {
      showMsg(error);
    }
  });
}

function downloadCSV(filename) {
  $("#dlfId").val(filename);
  $("#downloadCSVForm").submit();
}

function create_csv() {
//    showProgressDialog("Creating csv file...");
//
//  $.ajax({
//    url: "create_csv",
//    dataType: 'json',
//    success: function(data, status, xhr) {
//      if(hasErrors(data))
//        return false;
//      $("#streamDownLoadId").submit();
//      hideProgressDialog();
//      downloadCSV(data.message);
//    },
//    error: function(xhr, status, error) {
//      showMsg(error);
//    }
//  });

  $("#streamDownLoadId").submit();
}


