class Match < ActiveRecord::Base
	belongs_to :winner, :class_name => 'Player', :foreign_key => 'winner_id'
	belongs_to :loser, :class_name => 'Player', :foreign_key => 'loser_id'

	validate :winner_is_not_loser
	
	before_save :calculate_points_and_set_time
	after_save :add_points
	before_destroy :remove_points

	def winner_is_not_loser
		if winner_id == loser_id then
			errors.add_to_base( "A player can't play themself" )
		end
	end

	def calculate_points_and_set_time
		self.time = DateTime.now

		rank_diff = winner.rank - loser.rank
		points = ( rank_diff < 0 ) ? ( 11 - rank_diff.abs ) : ( 10 + rank_diff.abs )
		points = [0, [20, points].min].max

		self.winner_points = points
		self.loser_points = -points
	end

	def add_points
		winner.update_attributes :points => winner.points + winner_points
		loser.update_attributes :points => loser.points + loser_points
	end

	def remove_points
		winner.update_attributes :points => winner.points - winner_points
		loser.update_attributes :points => loser.points - loser_points
	end
end
