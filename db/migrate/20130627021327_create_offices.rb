class CreateOffices < ActiveRecord::Migration
  def change
    create_table :offices do |t|
      t.string :name
      t.float :longitude
      t.float :latitude
      t.float :longitude_min
      t.float :latitude_min
      t.float :longitude_max
      t.float :latitude_max
      t.float :range
      t.integer :company_id

      t.timestamps
    end
  end
end
