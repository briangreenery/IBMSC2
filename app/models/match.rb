class Match < ActiveRecord::Base
	belongs_to :winner, :class_name => 'Player', :foreign_key => 'winner_id'
	belongs_to :loser, :class_name => 'Player', :foreign_key => 'loser_id'

	def destroy
		winner.update_attributes :points => winner.points - winner_points
		loser.update_attributes :points => loser.points - loser_points
		super
	end

	def save
		rank_diff = winner.rank - loser.rank
		points = ( rank_diff < 0 ) ? ( 11 - rank_diff.abs ) : ( 10 + rank_diff.abs )
		points = [0, [20, points].min].max

		self.winner_points = points
		self.loser_points = -points

		winner.update_attributes :points => winner.points + winner_points
		loser.update_attributes :points => loser.points + loser_points
		super
	end
end
