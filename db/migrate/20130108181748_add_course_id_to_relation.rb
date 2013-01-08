class AddCourseIdToRelation < ActiveRecord::Migration
  def change
    add_column :question_cards, :course_id, :integer
  end
end
