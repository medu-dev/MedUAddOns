class AddIndexToQuestionsCards < ActiveRecord::Migration
  def change
    add_index :question_cards, :question_id
  end
end
