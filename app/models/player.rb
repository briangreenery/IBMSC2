class Player < ActiveRecord::Base

	def rank
		players = Player.all( :order => 'points DESC' )

  		lastPoints = -1
  		lastRank = 0
  		players.each_with_index do |player, index|
  			if player.points == lastPoints then
  				if player.id == id then
  					return lastRank
  				end
  			else
  				if player.id == id then
  					return index + 1
  				end
  				lastRank = index + 1
  			end
  			lastPoints = player.points
  		end

  		return 1
	end
end
