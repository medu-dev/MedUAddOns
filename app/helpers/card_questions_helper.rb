module CardQuestionsHelper

  def self.make_id(id, suffix)
    return id + suffix.to_s
  end

  def self.make_name(id)
    return id +  "__name"
  end


  def self.get_answer(question_id, user_id, card_id)

    answer = Answer.where(["question_id = ? AND user_id = ? AND card_id = ?", question_id, user_id, card_id])

    return answer.first()
  end

end
