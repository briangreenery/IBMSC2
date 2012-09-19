class AddReplayToMatches < ActiveRecord::Migration
  def self.up
    add_column :matches, :replay_file, :string
    add_column :matches, :replay_info, :string
  end

  def self.down
    remove_column :matches, :replay_info
    remove_column :matches, :replay_file
  end
end
