class ResultsController < ApplicationController
  def index
  	@players = Player.all( :order => 'points DESC' )
  	@matches = Match.all( :order => 'id DESC' )
  end

end
