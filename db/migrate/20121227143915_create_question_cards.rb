class CreateQuestionCards < ActiveRecord::Migration
  def change
    create_table :question_cards do |t|
      t.integer :question_id
      t.integer :card_id

      t.timestamps
    end
  end
end
