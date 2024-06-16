class AddUserIdToRelationships < ActiveRecord::Migration[6.1]
  def change
    add_column :relationships, :user_id, :integer
  end
end
