require 'csv'
namespace :get_all_answers do

  report_folder = "lib/tasks/reports/"

  desc "Get all answers"
  task :get_all => :environment do

    sql = "SELECT questions.body, courses.course_name, answers.user_id, answers.score FROM answers "
    sql << "LEFT OUTER JOIN questions ON questions.id = answers.question_id "
    sql << "LEFT OUTER JOIN courses ON answers.course_id = courses.course_id "
    sql << "ORDER BY questions.id, score "

    results = Answer.find_by_sql(sql)

    filename = make_filename()

    CSV.open(report_folder + filename, "w") do |csv|
      csv << ["Question", "Course", "Answer",  "User Id"]
      for r in results
        csv << [ r.body, r.course_name, r.score, r.user_id ]
      end
    end
  end

  def make_filename
    extension = ".csv"
    name = "all_answers" + extension
    return name
  end

end
