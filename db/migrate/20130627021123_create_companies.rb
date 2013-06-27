class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :contact
      t.boolean :status
      t.integer :deposit, :limit => 8

      t.timestamps
    end
  end
end
