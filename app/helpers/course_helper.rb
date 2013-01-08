module CourseHelper

  def self.select_all

    sql = "SELECT course_id, course_name "
    sql << "FROM courses "
    sql << "ORDER BY course_name"

    all = Course.find_by_sql(sql)

    return all
  end

end