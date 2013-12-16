require 'test_helper'

class CardQuestionsHelperTest < ActionController::TestCase

  def setup
    @cardid_1 = 72
    @cardid_2 = 48
    @body = "Why id the chicken cross the road?"
    @body2 = "Will we go over the fiscal cliff?"
    @user_id = 345
    @score = "5"
    @unknown_user = UtilHelper::UNKNOWN_USER
    @course_id = 12345
  end


  def test_is_existing_answer
    question = QuestionAdminHelper.create_question(@body)

    assert_equal(true, question.id > 0)
    assert_equal(true, question.body == @body)

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_1, @course_id)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_1)
    assert_equal(true, relationship.course_id == @course_id)

    answer = Answer.new
    answer.card_id = @cardid_1
    answer.question_id = question.id
    answer.score = @score.to_i
    answer.user_id  = @user_id
    answer.course_id = @course_id
    answer.save

    answer2 = Answer.find_by_user_id(@user_id)
    assert_not_nil(answer2)
    assert_equal(true, answer2.score == @score.to_i)
    assert_equal(true, answer2.card_id == @cardid_1)
    assert_equal(true, answer2.question_id == question.id)
    assert_equal(true, answer2.user_id == @user_id)
    assert_equal(true, answer2.course_id == @course_id)


    answer3 = CardQuestionsHelper.get_answer(question.id, @user_id, @cardid_1)
    assert_not_nil(answer3)
    assert_equal(true, answer3.score == @score.to_i)
    assert_equal(true, answer3.card_id == @cardid_1)
    assert_equal(true, answer3.question_id == question.id)
    assert_equal(true, answer3.user_id == @user_id)
    assert_equal(true, answer3.course_id == @course_id)

  end

  def test_is_new_answer
    question = QuestionAdminHelper.create_question(@body)

    answer = CardQuestionsHelper.get_answer(question.id, @user_id, @cardid_1)
    assert_nil(answer)
  end

end