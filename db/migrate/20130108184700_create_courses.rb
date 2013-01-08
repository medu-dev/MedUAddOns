class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :course_id
      t.string :course_name, :limit => 1024

      t.timestamps
    end
  end
end
