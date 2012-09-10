include ActionView::Helpers::NumberHelper

class WhoToPlayController < ApplicationController
  def index
    tournament = Tournament.current

    @players = tournament.players
    @player = nil

    if params.has_key? :player
      @player = Player.find_by_id params[:player]
    else
      @player = @players[rand @players.length]
    end

    points = {}
    tournament.standings.each do |standing|
      points[standing.player_id] = standing.points
    end

    @opponents = []

    @players.each do |opponent|
      next if opponent.id == @player.id

      player_points = points[@player.id]
      opponent_points = points[opponent.id]

      @opponents.push(
        { :player => opponent,
          :chance => number_to_percentage( 100 * Tournament.chance_to_win( player_points, opponent_points ), :precision => 0 ),
          :win => Tournament.adjustment( player_points, opponent_points ) + Tournament.bonus,
          :lose => -Tournament.adjustment( opponent_points, player_points ) + Tournament.bonus } )
    end

    @players.sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end
end
