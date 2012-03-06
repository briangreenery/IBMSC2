class AddTournamentToMatch < ActiveRecord::Migration
  def self.up
    add_column :matches, :tournament_id, :integer

    february = Tournament.create :name => 'February 1v1', :start_date => Time.local( 2012, 2, 1, 18 )
    Match.update_all( { :tournament_id => february.id } )
  end

  def self.down
    remove_column :matches, :tournament_id
  end
end
