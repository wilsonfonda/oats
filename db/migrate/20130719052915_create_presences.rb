class CreatePresences < ActiveRecord::Migration
  def change
    create_table :presences do |t|
      t.string :date
      t.boolean :flag
      t.string :note

      t.timestamps
    end
  end
end
