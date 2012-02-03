class Player < ActiveRecord::Base

  def name_with_code
    if character_code.nil?
      name
    else
      name + "." + character_code.to_s
    end
  end

  def games_played
    Match.count( :conditions => ['winner_id = ? or loser_id = ?', id, id] )
  end

	def rank
    Player.count( :conditions => ['points > ?', points] ) + 1
	end

end
