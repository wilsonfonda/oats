class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :division, :string
    add_column :users, :role, :char
    add_column :users, :access_token, :string
  end
end
