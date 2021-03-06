class Tournament < ActiveRecord::Base
  has_many :matches, :order => 'time DESC, id DESC'
  has_many :standings, :order => 'points DESC'
  has_many :players, :through => :standings, :order => 'points DESC'

  validates_presence_of :name, :start_date

  def self.current
    Tournament.order( :start_date ).last
  end

  def self.random_adjustment
    20 + rand( 31 )
  end

  def self.starting_points( league )
    1000
  end

  def self.handicap( player_league, opponent_league )
    if player_league.nil? || opponent_league.nil? || ( player_league - opponent_league ).abs < 2
      return 0
    end

    if player_league > opponent_league
      10 * ( player_league - opponent_league - 1 )
    else
      10 * ( player_league - opponent_league + 1 )
    end
  end

  def compute_results
    matches = self.matches

    wins = {}
    wins.default = 0
    losses = {}
    losses.default = 0

    matches.each do |match|
      wins[match.winner_id] += 1
      losses[match.loser_id] += 1
    end

    players = []
    points = {}
    ranks = {}

    last_points = -1
    rank = 0
    rank_count = 1

    self.standings.each do |standing|
      if wins[standing.player_id] > 0 || losses[standing.player_id] > 0

        players.push standing.player_id
        points[standing.player_id] = standing.points

        if standing.points != last_points
          last_points = standing.points
          rank += rank_count
          rank_count = 0
        end

        rank_count += 1
        ranks[standing.player_id] = rank
      end
    end

    names = {}
    leagues = {}

    Player.all.each do |player|
      names[player.id] = player.name
      leagues[player.id] = player.league_name
    end

    return players, names, leagues, points, ranks, wins, losses, matches
  end
end
