class InsertCourses < ActiveRecord::Migration
  def up
    Course.create :course_id => 2120, :course_name => "CLIPP Instructor"
    Course.create :course_id => 2340, :course_name => "eCLIPPs Instructor"
    Course.create :course_id => 2440, :course_name => "CLIPP Individual Subscriber"
    Course.create :course_id => 2800, :course_name => "SIMPLE Instructor"
    Course.create :course_id => 2820, :course_name => "SIMPLE"
    Course.create :course_id => 3381, :course_name => "Authoring Case"
    Course.create :course_id => 3420, :course_name => "CLIPP"
    Course.create :course_id => 3500, :course_name => "fmCASES Instructor"
    Course.create :course_id => 3641, :course_name => "WISE-MD"
    Course.create :course_id => 3660, :course_name => "WISE-MD Instructor"
    Course.create :course_id => 3840, :course_name => "fmCASES"
    Course.create :course_id => 3880, :course_name => "eCLIPPS"
    Course.create :course_id => 4040, :course_name => "SIMPLE Individual Subscriber"
    Course.create :course_id => 4041, :course_name => "WISE-MD Individual Subscriber"
    Course.create :course_id => 5760, :course_name => "fmCASES Individual Subscriber"
    Course.create :course_id => 6100, :course_name => "CORE Instructor-Original"
    Course.create :course_id => 6101, :course_name => "CORE Instructor"
    Course.create :course_id => 6220, :course_name => "CORE"
    Course.create :course_id => 6221, :course_name => "CORE Individual Subscriber"
    Course.create :course_id => 6660, :course_name => "Original CORE"
    Course.create :course_id => 7022, :course_name => "CLIPP Oral Presentation Case"
  end

  def down
  end
end

