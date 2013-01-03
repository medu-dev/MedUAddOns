var ERROR = "error"
var SUCCESS = "success"

var STAGING = "staging";
var DEVELOPMENT = "development"

var runTimeEnvironment = "";

function hasErrors(data) {
  var hasError = false;

  if(data.status == ERROR) {
    showMsg(data.message);
    hasError = true;
  }

  return hasError;
}

function hasErrorsDebug(data) {
  var hasError = false;

  if(data.status == ERROR) {
    showMsgDebug(data.message);
    hasError = true;
  }

  return hasError;
}

function showMsgDebug(msg) {
  if(runTimeEnvironment != undefined && runTimeEnvironment.length > 0) {
    if(runTimeEnvironment == STAGING || runTimeEnvironment == DEVELOPMENT) {
      alert(msg);
    }
  }
}