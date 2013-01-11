require 'csv'

class QuestionAdminController < ApplicationController
  @@csv_folder = "public/csv_files/"

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

  def get_all_answers
    begin
      all = QuestionAdminHelper.select_all_answsers()
      response = AjaxResponse.new(AjaxResponse::SUCCESS, all)

    rescue Exception => exception
      logger.error "---- Exception: question_admin/get_all_answers " + exception.to_s
      response = AjaxResponse.new(AjaxResponse::ERROR, exception.to_s)
    end

    render json: response
  end

  def download_csv
      filename = params["downloadFilename"]
      path = @@csv_folder + filename
      begin
        # setting :stream to false means that the file will be read in it's entirety before send_file
        # executes. This allows deleting the file after send_file returns. The problem with this
        # approach is that if files are large it could cause memory issues on the server and take a
        # long time.
        # link about sending files in guides: http://guides.rubyonrails.org/action_controller_overview.html#sending-files
        send_file(path,
                  :disposition => "attachment",
                  :encoding => "utf8",
                  :type => "text/csv",
                  :stream =>false)

      #File.delete(path)

      rescue Exception => exception
        logger.error "---- Exception: question_admin/download_csv " + exception.to_s
      end
  end

  def create_csv
    begin
      results = QuestionAdminHelper.select_all_answsers()

      filename = make_filename()

      CSV.open(@@csv_folder + filename, "w") do |csv|
        csv << ["Question", "Course", "Answer",  "Card Name", "Card Id", "Case Name", "Case Id", "User Id", "Group Id"]
        for r in results
          csv << [ r.body, r.course_name, r.score, r.card_name, r.card_id, r.case_name, r.case_id, r.user_id, r.group_id ]
        end
      end
        response = AjaxResponse.new(AjaxResponse::SUCCESS, filename)
    rescue Exception => exception
      logger.error "---- Exception: question_admin/create_csv " + exception.to_s
      response = AjaxResponse.new(AjaxResponse::ERROR, exception.to_s)
    end
    render json: response
  end

  def make_filename
    extension = ".csv"
    identifier = QuestionAdminHelper.get_unique_identifier
    name = "answers_" + identifier + extension
    return name
  end

  def question_help
   x = 0
  end
end
