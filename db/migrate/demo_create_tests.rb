class CreateTests < ActiveRecord::Migration
  def self.up
    create_table :tests do |t|
      t.integer :user_id
      t.string :name

      t.timestamps
    end
    add_foreign_key :tests, :user_id, :references => :users
  end

  def self.down
    drop_table :tests
  end
end
