require 'test_helper'
require 'run_time_environment'

class CourseHelperTest < ActionView::TestCase

  def test_select_all_courses
    all = CourseHelper.select_all()
    assert_not_nil(all)
  end

end