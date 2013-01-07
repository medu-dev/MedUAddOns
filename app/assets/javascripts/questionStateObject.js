var currentQuestionMode = new questionStateObject();

var EDIT = "edit";
var ADD = "add";

function questionStateObject() {
  this.mode = "";
}

questionStateObject.prototype.makeEdit = function() {
  this.mode = EDIT;
}

questionStateObject.prototype.makeAdd = function() {
  this.mode = ADD;
}

questionStateObject.prototype.isEdit = function() {
  return this.mode == EDIT;
}

questionStateObject.prototype.isAdd = function() {
  return this.mode == ADD;
}