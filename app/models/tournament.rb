class Tournament < ActiveRecord::Base
	has_many :matches

	def self.week_diff( match_date, start_date )
		diff = match_date - start_date
		1 + ( diff / 7.days ).floor
	end

	def self.this_week
		week_diff Time.now.getlocal, Tournament.current.start_date
	end

	def self.current
		Tournament.all[0]
	end

	def self.chance_to_win( winner_points, loser_points )
		q_winner = 10.0 ** ( winner_points / 400.0 )
		q_loser = 10.0 ** ( loser_points / 400.0 )
		q_winner / ( q_winner + q_loser )
	end

	def self.adjustment( winner_points, loser_points )
		k = 32
		expected = Tournament.chance_to_win winner_points, loser_points
		( k * ( 1.0 - expected ) ).round
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
end
