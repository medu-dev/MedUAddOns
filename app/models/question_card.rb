class QuestionCard < ActiveRecord::Base
  attr_accessible :card_id, :question_id, :course_id

  belongs_to :question
end
