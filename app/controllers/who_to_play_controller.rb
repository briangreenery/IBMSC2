include ActionView::Helpers::NumberHelper

class WhoToPlayController < ApplicationController
  def index
    @players = Player.all
    @player = nil
    @opponents = []

    if !@players.empty?

      if params.has_key? :player
        @player = Player.find_by_id params[:player]
      elsif !cookies[:who_to_play].nil?
        @player = Player.find_by_id cookies[:who_to_play]
      else
        @player = @players[rand @players.length]
      end

      cookies[:who_to_play] = { :value => @player.id, :expires => 1.year.from_now }

      points = {}
      Tournament.current.standings.each do |standing|
        points[standing.player_id] = standing.points
      end

      player_points = points[@player.id] || Tournament.starting_points( @player.league )

      @players.each do |opponent|
        next if opponent.id == @player.id

        opponent_points = points[opponent.id] || Tournament.starting_points( opponent.league )

        @opponents.push(
          { :player => opponent,
            :chance => number_to_percentage( 100 * Tournament.chance_to_win( player_points, opponent_points ), :precision => 0 ),
            :win => Tournament.adjustment( player_points, opponent_points ) + Tournament.bonus,
            :lose => -Tournament.adjustment( opponent_points, player_points ) + Tournament.bonus,
            :handicap => Tournament.handicap( @player.league, opponent.league ) } )
      end

      @players.sort! { |a,b| a.name.downcase <=> b.name.downcase }
      @opponents.sort! { |a,b| b[:win] <=> a[:win] }

    end
  end
end
