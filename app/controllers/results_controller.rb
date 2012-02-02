class ResultsController < ApplicationController
  def index
  	@players = Player.all( :order => 'points DESC' )
  	@matches = Match.all( :order => 'id DESC' )

  	@ranks = Array.new

  	lastPoints = -1
  	lastRank = 0
  	@players.each_with_index do |player, index|
  		if player.points == lastPoints then
  			@ranks.push lastRank
  		else
  			@ranks.push index + 1
  			lastRank = index + 1
  		end

  		lastPoints = player.points
  	end
  end

end
