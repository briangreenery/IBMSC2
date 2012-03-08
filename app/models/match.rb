include ActionView::Helpers::DateHelper

class Match < ActiveRecord::Base
	belongs_to :winner, :class_name => 'Player', :foreign_key => 'winner_id'
	belongs_to :loser, :class_name => 'Player', :foreign_key => 'loser_id'
	belongs_to :tournament

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
		self.tournament = Tournament.current

		adjustment = Tournament.adjustment( winner.points, loser.points )

		self.winner_points = adjustment + Tournament.bonus
		self.loser_points = -adjustment + Tournament.bonus
	end

	def add_points
		winner_standing = Standing.where( :player_id => winner_id, :tournament_id => tournament.id ).first
		loser_standing = Standing.where( :player_id => loser_id, :tournament_id => tournament.id ).first

		winner_standing.update_attributes :points => winner_standing.points + winner_points
		loser_standing.update_attributes :points => loser_standing.points + loser_points
	end

	def remove_points
		winner_standing = Standing.where( :player_id => winner_id, :tournament_id => tournament.id ).first
		loser_standing = Standing.where( :player_id => loser_id, :tournament_id => tournament.id ).first

		winner_standing.update_attributes :points => winner_standing.points - winner_points
		loser_standing.update_attributes :points => loser_standing.points - loser_points
	end

	def week_played
		Tournament.week_diff time, tournament.start_date
	end
end
