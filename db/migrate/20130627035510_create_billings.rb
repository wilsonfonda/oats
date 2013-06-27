class CreateBillings < ActiveRecord::Migration
  def change
    create_table :billings do |t|
      t.integer :total_employee
      t.integer :price
      t.datetime :payment_date
      t.integer :month
      t.integer :company_id

      t.timestamps
    end
  end
end
