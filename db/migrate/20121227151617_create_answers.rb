class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.integer :score
      t.integer :user_id
      t.integer :card_id

      t.timestamps
    end

    add_index :answers, :question_id
    add_index :answers, :user_id
    add_index :answers, :card_id
  end
end
