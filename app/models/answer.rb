class Answer < ActiveRecord::Base
  attr_accessible :card_id, :question_id, :score, :user_id, :course_id

  belongs_to :question
end
