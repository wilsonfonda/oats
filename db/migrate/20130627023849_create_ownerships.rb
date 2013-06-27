class CreateOwnerships < ActiveRecord::Migration
  def change
    create_table :ownerships do |t|
      t.integer :company_id
      t.integer :owner_id

      t.timestamps
    end
	  
  add_index :ownerships, :company_id
  add_index :ownerships, :owner_id
  add_index :ownerships, [:company_id, :owner_id], unique: true
  end
end
