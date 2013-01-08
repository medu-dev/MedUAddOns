class AddCourseIdIndex < ActiveRecord::Migration
  def up
    add_index :answers, :course_id
  end

  def down
  end
end
