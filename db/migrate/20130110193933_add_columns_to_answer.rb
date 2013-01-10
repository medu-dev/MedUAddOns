class AddColumnsToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :case_name, :string, :limit => 2048
    add_column :answers, :case_id, :integer
    add_column :answers, :card_name, :string, :limit => 2048
    add_column :answers, :group_id, :integer
  end
end
