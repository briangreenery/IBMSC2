class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :winner
      t.integer :loser
      t.datetime :time

      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end
