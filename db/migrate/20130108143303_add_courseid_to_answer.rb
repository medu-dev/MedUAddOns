class AddCourseidToAnswer < ActiveRecord::Migration
  def up
    add_column :answers, :course_id, :integer
  end
end
