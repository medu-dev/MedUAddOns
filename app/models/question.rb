class Question < ActiveRecord::Base

  attr_accessible :body

  has_many :question_cards, :dependent => :destroy
  has_many :answers, :dependent => :destroy
end
