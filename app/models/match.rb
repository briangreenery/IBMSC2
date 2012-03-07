include ActionView::Helpers::DateHelper

class Match < ActiveRecord::Base
	belongs_to :winner, :class_name => 'Player', :foreign_key => 'winner_id'
	belongs_to :loser, :class_name => 'Player', :foreign_key => 'loser_id'
	belongs_to :tournament

	validate :winner_is_not_loser
	validate :only_play_once_per_week
	
	before_save :calculate_points_and_set_time
	after_save :add_points
	before_destroy :remove_points

	def winner_is_not_loser
		if winner_id == loser_id then
			errors.add_to_base( "A player can't play themself" )
		end
	end

	def only_play_once_per_week
		last_game = Match.find( :first,
		                        :conditions => ['(winner_id = ? and loser_id = ?) or (winner_id = ? and loser_id = ?)',
			                                     winner_id, loser_id, loser_id, winner_id],
			                    :order => 'time DESC' )
		
		if !last_game.nil? && last_game.week_played == Tournament.this_week
			errors.add_to_base( winner.name + ' has already played ' + loser.name + ' this week (' + time_ago_in_words( last_game.time ) + ' ago)' )
		end
	end

	def calculate_points_and_set_time
		self.time = DateTime.now
		self.tournament = Tournament.current

		k = 32

		q_winner = 10.0 ** ( winner.points / 400.0 )
		q_loser = 10.0 ** ( loser.points / 400.0 )

		expected = q_winner / ( q_winner + q_loser )
		adjustment = ( k * ( 1.0 - expected ) ).round

		self.winner_points = adjustment
		self.loser_points = -adjustment
	end

	def add_points
		winner.update_attributes :points => winner.points + winner_points
		loser.update_attributes :points => loser.points + loser_points
	end

	def remove_points
		winner.update_attributes :points => winner.points - winner_points
		loser.update_attributes :points => loser.points - loser_points
	end

	def week_played
		Tournament.week_diff time, tournament.start_date
	end
end
