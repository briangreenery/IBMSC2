class ResultsController < ApplicationController
  def index
  	@players = Tournament.current.players
  	@matches = Tournament.current.matches
  	@maps = Map.all( :order => "lower( name )" )
  end
end
