class AddPointsToMatches < ActiveRecord::Migration
  def self.up
    add_column :matches, :winner_points, :integer
    add_column :matches, :loser_points, :integer
  end

  def self.down
    remove_column :matches, :loser_points
    remove_column :matches, :winner_points
  end
end
