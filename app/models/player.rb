class Player < ActiveRecord::Base
  has_many :games_won, :class_name => "Match", :foreign_key => "winner_id", :dependent => :delete_all
  has_many :games_lost, :class_name => "Match", :foreign_key => "loser_id", :dependent => :delete_all
  has_many :standings
  has_many :tournaments, :through => :standings

  validates :name, :presence => true
  validates_format_of :character_code, :with => /^$|^[0-9]{2,3}$/, :message => "must be 3 or 4 digits long"

  def name_with_code
    if character_code.nil?
      name
    else
      name + "." + character_code.to_s
    end
  end

  def points
    standing = standings.where( :tournament_id => Tournament.current.id ).first
    standing.nil? ? Tournament.starting_points : standing.points
  end

  def rank
    1 + Standing.count( :conditions => ['tournament_id = ? and points > ?', Tournament.current.id, points] )
  end

  def record_this_season
    wins = Match.count( :conditions => ['winner_id = ? and tournament_id = ?', id, Tournament.current.id] )
    losses = Match.count( :conditions => ['loser_id = ? and tournament_id = ?', id, Tournament.current.id] )
    wins.to_s + '-' + losses.to_s
  end

  def record_all_time
    wins = Match.count( :conditions => ['winner_id = ?', id] )
    losses = Match.count( :conditions => ['loser_id = ?', id] )
    wins.to_s + '-' + losses.to_s
  end

  def league_name
    return "master"   if league == 1
    return "diamond"  if league == 2
    return "platinum" if league == 3
    return "gold"     if league == 4
    return "silver"   if league == 5
    return "bronze"
  end
end
