include ActionView::Helpers::NumberHelper

class WhoToPlayController < ApplicationController
  def index
    @players = Player.all
    @player = nil
    @opponents = []

    if !@players.empty?

      if params.has_key? :player
        @player = Player.find_by_id params[:player]
      elsif !cookies[:who_to_play].nil?
        @player = Player.find_by_id cookies[:who_to_play]
      else
        @player = @players[rand @players.length]
      end

      cookies[:who_to_play] = { :value => @player.id, :expires => 1.year.from_now }

      @players.sort! { |a,b| a.name.downcase <=> b.name.downcase }

      @players.each do |opponent|
        next if opponent.id == @player.id

        @opponents.push(
          { :player => opponent,
            :handicap => Tournament.handicap( @player.league, opponent.league ) } )
      end
    end

    @random_map = [ 'Antiga Shipyard', 'Cloud Kingdom', 'Condemned Ridge', 'Daybreak',
                    'Entombed Valley', 'Ohana', 'Shakuras Plateau', 'Tal\'Darim Altar' ].choice
  end
end
