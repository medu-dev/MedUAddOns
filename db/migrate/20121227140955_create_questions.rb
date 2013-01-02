class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :body, :limit => 1024

      t.timestamps
    end
  end
end
