class AddPlayerController < ApplicationController
	def add_player
	end

	def add_new_player
		@player = Player.new
	end

	def add_existing_player
		@players = []

		Player.all( :order => "lower( name )" ).each do |player|
			@players.push player if player.points == 0
		end
	end

	def create_new_player
	end

	def create_existing_player
		player = Player.find_by_id params[:player]

		if player.points == 0
			Standing.create :tournament => Tournament.current, :player => player, :points => 1000
		end

		redirect_to '/'
	end
end
