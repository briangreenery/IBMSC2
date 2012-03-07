include ActionView::Helpers::NumberHelper

class WhoToPlayController < ApplicationController
  def index
  	@players = Player.all( :order => 'points DESC' )
  	@player = nil

  	if params.has_key? :player
  		@player = Player.find_by_id params[:player]
  	else
  		@player = @players[rand @players.length]
  	end

  	@opponents = []

  	@players.each do |opponent|
  		next if opponent.id == @player.id

  		@opponents.push(
  			{ :player => opponent,
  		      :chance => number_to_percentage( 100 * Tournament.chance_to_win( @player.points, opponent.points ), :precision => 0 ),
  		      :win => Tournament.adjustment( @player.points, opponent.points ) + Tournament.bonus,
  		      :lose => -Tournament.adjustment( opponent.points, @player.points ) + Tournament.bonus,
  		      :handicap => Tournament.handicap( @player.league, opponent.league ) } )
  	end

  	@players.sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end
end
