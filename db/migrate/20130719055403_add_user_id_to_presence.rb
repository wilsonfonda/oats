class AddUserIdToPresence < ActiveRecord::Migration
  def change
  	add_column :presences, :user_id, :integer
  end
end
