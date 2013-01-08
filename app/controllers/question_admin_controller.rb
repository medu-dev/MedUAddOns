class QuestionAdminController < ApplicationController

  def init

  end

  def get_all

    begin
      all = QuestionAdminHelper.select_all()
      response = AjaxResponse.new(AjaxResponse::SUCCESS, all)

    rescue Exception => exception
      logger.error "---- Exception: question_admin/get_all " + exception.to_s
      response = AjaxResponse.new(AjaxResponse::ERROR, exception.to_s)
    end

    render json: response
  end

  def get_courses
    begin
      all = CourseHelper.select_all()
      response = AjaxResponse.new(AjaxResponse::SUCCESS, all)

    rescue Exception => exception
      logger.error "---- Exception: question_admin/get_courses " + exception.to_s
      response = AjaxResponse.new(AjaxResponse::ERROR, exception.to_s)
    end

    render json: response
  end

  def add_question

    question = params["question"];

    begin
      # create the question
      QuestionAdminHelper.create_question(question)
      all = QuestionAdminHelper.select_all()
      response = AjaxResponse.new(AjaxResponse::SUCCESS, all)

    rescue Exception => exception
      logger.error "---- Exception: question_admin/add_question " + exception.to_s
      response = AjaxResponse.new(AjaxResponse::ERROR, exception.to_s)
    end

    render json: response
  end

  def edit_question

    question_body = params["question"];
    question_id = params["question_id"]

    begin
      # get the question and update it
      question = Question.find(question_id.to_i)
      question.body = question_body;
      question.save

      all = QuestionAdminHelper.select_all()
      response = AjaxResponse.new(AjaxResponse::SUCCESS, all)

    rescue Exception => exception
      logger.error "---- Exception: question_admin/edit_question " + exception.to_s
      response = AjaxResponse.new(AjaxResponse::ERROR, exception.to_s)
    end

    render json: response
  end

  def delete_question

    question_id = params["id"]

    begin
      # get the question and delete it and any associated relations
      question = Question.find(question_id)
      question.destroy()

      all = QuestionAdminHelper.select_all()
      response = AjaxResponse.new(AjaxResponse::SUCCESS, all)

    rescue Exception => exception
      logger.error "---- Exception: question_admin/delete_question " + exception.to_s
      response = AjaxResponse.new(AjaxResponse::ERROR, exception.to_s)
    end

    render json: response
  end

  def delete_relationship

    relationship_id = params["id"]

    begin
      # get relationship and remove it
      relation  = QuestionCard.find(relationship_id)
      relation.destroy()

      all = QuestionAdminHelper.select_all()
      response = AjaxResponse.new(AjaxResponse::SUCCESS, all)

    rescue Exception => exception
      logger.error "---- Exception: question_admin/delete_relationship " + exception.to_s
      response = AjaxResponse.new(AjaxResponse::ERROR, exception.to_s)
    end

    render json: response
  end


  def add_relation

    question_id = params["question_id"];
    card_id = params["card_id"]
    course_id = params["course_id"]

    begin
      # create the relationship
      QuestionAdminHelper.create_relationship(question_id.to_i, card_id.to_i, course_id.to_i)
      all = QuestionAdminHelper.select_all()
      response = AjaxResponse.new(AjaxResponse::SUCCESS, all)

    rescue Exception => exception
      logger.error "---- Exception: question_admin/add_relation " + exception.to_s
      response = AjaxResponse.new(AjaxResponse::ERROR, exception.to_s)
    end

    render json: response
  end
end
