module QuestionAdminHelper

  def self.create_question(value)
    question = Question.new

    question.body = value
    question.save

    return question
  end

  def self.create_relationship(question_id, card_id, course_id)
    relation = QuestionCard.new
    relation.question_id = question_id
    relation.card_id = card_id
    relation.course_id = course_id

    relation.save

    return relation
  end

  def self.select_question(id)
    return Question.find(id)
  end

  def self.select_all()
    sql = "SELECT questions.id AS questions_id, questions.body, question_cards.card_id,  question_cards.id AS relation_id, "
    sql << "courses.course_name AS course_name "
    sql << "FROM questions LEFT OUTER JOIN question_cards ON question_cards.question_id = questions.id "
    sql << "LEFT OUTER JOIN courses ON question_cards.course_id = courses.course_id "
    sql << "ORDER BY questions.id, course_name"

    all = Question.find_by_sql(sql)

    return all
  end

  def self.select_questions_for_card(card_id)
    sql = "SELECT questions.id AS questions_id, questions.body "
    sql << "FROM questions JOIN question_cards ON question_cards.question_id = questions.id "
    sql << "WHERE question_cards.card_id = " + card_id.to_s
    sql << "ORDER BY questions.body"

    all = Question.find_by_sql(sql)

    return all
  end


end
