class CreateTournaments < ActiveRecord::Migration
  def self.up
    create_table :tournaments do |t|
      t.string :name
      t.datetime :start_date

      t.timestamps
    end
    Tournament.create :name => 'February 1v1', :start_date => Time.local( 2012, 2, 1, 18 )
  end

  def self.down
    drop_table :tournaments
  end
end
