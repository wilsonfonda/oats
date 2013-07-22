class ChangeDateFormatInPresence < ActiveRecord::Migration
  def change
    change_column :presences, :date, :string
  end
end
