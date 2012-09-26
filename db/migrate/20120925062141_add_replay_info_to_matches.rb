class AddReplayInfoToMatches < ActiveRecord::Migration
  def self.up
    add_column :matches, :map, :string
    add_column :matches, :winner_race, :string, :limit => 1
    add_column :matches, :loser_race, :string, :limit => 1
    add_column :matches, :start_time, :integer
    add_column :matches, :length, :integer
    add_column :matches, :sha1, :string, :limit => 40
    add_index :matches, :sha1

    Match.reset_column_information
    Match.where( 'replay_file is not null' ).each do |match|
      replay_info = Match.parse_replay( File.join( 'public', 'replays', match.replay_file ) )

      match.update_column :map,         replay_info['map']
      match.update_column :winner_race, replay_info['winner_race']
      match.update_column :loser_race,  replay_info['loser_race']
      match.update_column :start_time,  replay_info['start_time']
      match.update_column :length,      replay_info['length']
      match.update_column :sha1,        replay_info['sha1']
    end
  end

  def self.down
    remove_column :matches, :sha1
    remove_column :matches, :length
    remove_column :matches, :start_time
    remove_column :matches, :loser_race
    remove_column :matches, :winner_race
    remove_column :matches, :map
  end
end
