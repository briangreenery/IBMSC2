class AddLeagueToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :league, :integer
  end

  def self.down
    remove_column :players, :league
  end
end
