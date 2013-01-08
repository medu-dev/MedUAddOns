require 'test_helper'

class CardQuestionsControllerTest < ActionController::TestCase

  def setup
    @cardid_1 = 72
    @cardid_2 = 48
    @body = "Why id the chicken cross the road?"
    @body2 = "Will we go over the fiscal cliff?"
    @user_id = 345
    @score = "5"
    @unknown_user = UtilHelper::UNKNOWN_USER
    @courseid = 1620
  end

  def test_answer
    question = QuestionAdminHelper.create_question(@body)

    env = Rack::MockRequest.env_for("/",
          :params => {UtilHelper::PARAM_CARDID => @cardid_1.to_s,
                      UtilHelper::PARAM_USERID => @user_id.to_s,
                      UtilHelper::PARAM_QUESTIONID => question.id.to_s,
                      UtilHelper::PARAM_SCORE => @score,
                      UtilHelper::PARAM_COURSEID => @courseid.to_s })

    endpoint = CardQuestionsController.action(:save_answer)
    body = endpoint.call(env)

    assert_not_nil(body)
    answer = Answer.find_by_user_id(@user_id)
    assert_not_nil(answer)
    assert_equal(true, answer.score == @score.to_i)
    assert_equal(true, answer.card_id == @cardid_1)
    assert_equal(true, answer.question_id == question.id)
    assert_equal(true, answer.user_id == @user_id)
    assert_equal(true, answer.course_id == @courseid)

  end

  def test_answer_no_user_id
    question = QuestionAdminHelper.create_question(@body)

    env = Rack::MockRequest.env_for("/",
                                    :params => {UtilHelper::PARAM_CARDID => @cardid_1.to_s,
                                                UtilHelper::PARAM_USERID => @unknown_user,
                                                UtilHelper::PARAM_QUESTIONID => question.id.to_s,
                                                UtilHelper::PARAM_SCORE => @score,
                                                UtilHelper::PARAM_COURSEID => @courseid.to_s})

    endpoint = CardQuestionsController.action(:save_answer)
    body = endpoint.call(env)

    assert_not_nil(body)
    answer = Answer.find_by_card_id(@cardid_1)
    assert_not_nil(answer)
    assert_equal(true, answer.score == @score.to_i)
    assert_equal(true, answer.card_id == @cardid_1)
    assert_equal(true, answer.question_id == question.id)
    assert_equal(true, answer.course_id == @courseid)
    assert_nil(answer.user_id)
  end

  def test_update_answer
    # seed the db with an answer
    question = QuestionAdminHelper.create_question(@body)
    new_score = "3"

    assert_equal(true, question.id > 0)
    assert_equal(true, question.body == @body)

    relationship = QuestionAdminHelper.create_relationship(question.id, @cardid_1, @courseid)
    assert_equal(true, relationship.id > 0)
    assert_equal(true, relationship.question_id == question.id)
    assert_equal(true, relationship.card_id == @cardid_1)
    assert_equal(true, relationship.course_id == @courseid)

    answer = Answer.new
    answer.card_id = @cardid_1
    answer.question_id = question.id
    answer.score = @score.to_i
    answer.user_id  = @user_id
    answer.course_id = @courseid
    answer.save

    answer2 = Answer.find_by_user_id(@user_id)
    assert_not_nil(answer2)
    assert_equal(true, answer2.score == @score.to_i)
    assert_equal(true, answer2.card_id == @cardid_1)
    assert_equal(true, answer2.question_id == question.id)
    assert_equal(true, answer2.user_id == @user_id)
    assert_equal(true, answer2.course_id == @courseid)

    env = Rack::MockRequest.env_for("/",
                                    :params => {UtilHelper::PARAM_CARDID => @cardid_1.to_s,
                                                UtilHelper::PARAM_USERID => @user_id.to_s,
                                                UtilHelper::PARAM_QUESTIONID => question.id.to_s,
                                                UtilHelper::PARAM_SCORE => new_score,
                                                UtilHelper::PARAM_COURSEID => @courseid.to_s })

    endpoint = CardQuestionsController.action(:save_answer)
    body = endpoint.call(env)

    relation = Answer.where(["question_id = ? AND user_id = ? AND card_id = ?", question.id, @user_id, @cardid_1])
    answer3 = relation.all()
    assert_equal(1, answer3.length)
    assert_equal(new_score.to_i, answer3[0].score)
  end

end
