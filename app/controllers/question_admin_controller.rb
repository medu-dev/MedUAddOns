class QuestionAdminController < ApplicationController

  def init

    @all_questions = QuestionAdminHelper.select_all()

  end

end
