class ResultsController < ApplicationController
  def index
    tournament = Tournament.current

    @matches = tournament.matches

    @wins = {}
    @wins.default = 0
    @losses = {}
    @losses.default = 0

    @matches.each do |match|
      @wins[match.winner_id] += 1
      @losses[match.loser_id] += 1
    end

    @players = []
    @points = {}
    @ranks = {}

    last_points = -1
    rank = 0
    rank_count = 1

    Standing.where( :tournament_id => tournament.id ).order( 'points DESC' ).each do |standing|
      if @wins[standing.player_id] > 0 || @losses[standing.player_id] > 0

        @players.push standing.player_id
        @points[standing.player_id] = standing.points

        if standing.points != last_points
          last_points = standing.points
          rank += rank_count
          rank_count = 0
        end

        rank_count += 1
        @ranks[standing.player_id] = rank
      end
    end

    @names = {}
    @leagues = {}

    Player.all.each do |player|
      @names[player.id] = player.name
      @leagues[player.id] = player.league_name
    end

  end
end
