class CreateWorktimes < ActiveRecord::Migration
  def change
    create_table :worktimes do |t|
      t.datetime :checkin
      t.datetime :checkout
      t.string :place_checkin
      t.string :place_checkout
      t.integer :user_id

      t.timestamps
    end
  end
end
