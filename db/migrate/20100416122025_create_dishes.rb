class CreateDishes < ActiveRecord::Migration
  def self.up
    create_table :dishes do |t|
      t.integer :category_id
      t.string  :title
      t.text    :ingredients
      t.text    :instructions
      t.integer :is_deleted, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :dishes
  end
end
