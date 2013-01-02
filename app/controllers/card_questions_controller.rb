class CardQuestionsController < ApplicationController

  #QUESTIONS_TEMPLATE_PATH = "app/assets/javascripts/embedquestions.js"
  QUESTIONS_TEMPLATE_PATH = "public/javascript/embedquestions.js"

  def init
    var = ""

    if UtilHelper.is_card_supported(params)
      begin
        card_id = params[UtilHelper::PARAM_CARDID]
        user_id = UtilHelper.get_user_id(params)

        var  = UtilHelper.read_template(QUESTIONS_TEMPLATE_PATH)
        var =  UtilHelper.replace_card_id_tag(var, card_id)
        var =  UtilHelper.replace_user_id_tag(var, user_id)

      rescue   Exception => exception
        logger = QuestionLogger.new(QuestionLogger::LOGFILE)
        logger.log_error(exception.to_s)
        var = ""
      end
    end

    render  js: var
  end

  def show
    @card_id = params[UtilHelper::PARAM_CARDID]
    @user_id = UtilHelper.get_user_id(params)
    @questions = nil

    begin
      @questions = QuestionAdminHelper.select_questions_for_card(@card_id)
    rescue Exception => exception
      logger = QuestionLogger.new(QuestionLogger::LOGFILE)
      logger.log_error("CardQuestionsController.show error: " + exception.to_s)
    end
  end

  def save_answer
    response = nil

    begin
      card_id = params[UtilHelper::PARAM_CARDID]
      user_id = params[UtilHelper::PARAM_USERID]
      question_id = params[UtilHelper::PARAM_QUESTIONID]
      score = params[UtilHelper::PARAM_SCORE]

      answer = Answer.new
      answer.card_id = card_id.to_i
      answer.question_id = question_id.to_i
      answer.score = score.to_i
      if(user_id != UtilHelper::UNKNOWN_USER)
        answer.user_id  = user_id.to_i
      end
      answer.save

      response = AjaxResponse.new(AjaxResponse::SUCCESS, "success")

    rescue Exception => exception
      logger = QuestionLogger.new(QuestionLogger::LOGFILE)
      logger.log_error("CardQuestionsController.save_answer error: " + exception.to_s)
      response = AjaxResponse.new(AjaxResponse::ERROR, exception.to_s)
    end

    render json: response

  end

end
