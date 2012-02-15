class ResultsController < ApplicationController
  def index
  	@players = Player.all( :order => 'points DESC' )
  	@matches = Match.all( :order => 'time DESC, id DESC' )
  	@maps = Map.all
  end

end
