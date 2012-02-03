class AddCharCodeToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :character_code, :integer
  end

  def self.down
    remove_column :players, :character_code
  end
end
