class ChangeWinnerLoserColumns < ActiveRecord::Migration
  def self.up
  	rename_column :matches, :winner, :winner_id
  	rename_column :matches, :loser, :loser_id
  end

  def self.down
  	rename_column :matches, :winner_id, :winner
  	rename_column :matches, :loser_id, :loser
  end
end
