class ResultsController < ApplicationController
  def index
    @tournament = Tournament.current
    @players = []
    @matches = []

    if !@tournament.nil?
      @players, @names, @leagues, @points, @ranks, @wins, @losses, @matches = @tournament.compute_results
    end
  end
end
