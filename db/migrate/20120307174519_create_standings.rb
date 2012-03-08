class CreateStandings < ActiveRecord::Migration
  def self.up
    create_table :standings do |t|
      t.integer :tournament_id
      t.integer :player_id
      t.integer :points

      t.timestamps
    end

    Player.all.each do |player|
      Standing.create :tournament => Tournament.current, :player => player, :points => player.read_attribute( :points )
    end
  end

  def self.down
    drop_table :standings
  end
end
