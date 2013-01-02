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
  end

  def test_answer
    question = QuestionAdminHelper.create_question(@body)

    env = Rack::MockRequest.env_for("/",
          :params => {UtilHelper::PARAM_CARDID => @cardid_1.to_s,
                      UtilHelper::PARAM_USERID => @user_id.to_s,
                      UtilHelper::PARAM_QUESTIONID => question.id.to_s,
                      UtilHelper::PARAM_SCORE => @score })

    endpoint = CardQuestionsController.action(:save_answer)
    body = endpoint.call(env)

    assert_not_nil(body)
    answer = Answer.find_by_user_id(@user_id)
    assert_not_nil(answer)
    assert_equal(true, answer.score == @score.to_i)
    assert_equal(true, answer.card_id == @cardid_1)
    assert_equal(true, answer.question_id == question.id)
    assert_equal(true, answer.user_id == @user_id)

  end

  def test_answer_no_user_id
    question = QuestionAdminHelper.create_question(@body)

    env = Rack::MockRequest.env_for("/",
                                    :params => {UtilHelper::PARAM_CARDID => @cardid_1.to_s,
                                                UtilHelper::PARAM_USERID => @unknown_user,
                                                UtilHelper::PARAM_QUESTIONID => question.id.to_s,
                                                UtilHelper::PARAM_SCORE => @score })

    endpoint = CardQuestionsController.action(:save_answer)
    body = endpoint.call(env)

    assert_not_nil(body)
    answer = Answer.find_by_card_id(@cardid_1)
    assert_not_nil(answer)
    assert_equal(true, answer.score == @score.to_i)
    assert_equal(true, answer.card_id == @cardid_1)
    assert_equal(true, answer.question_id == question.id)
    assert_nil(answer.user_id)
  end


end
