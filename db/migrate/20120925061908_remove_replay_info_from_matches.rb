class RemoveReplayInfoFromMatches < ActiveRecord::Migration
  def self.up
  	remove_column :matches, :replay_info
  end

  def self.down
  	add_column :matches, :replay_info, :string
  end
end
