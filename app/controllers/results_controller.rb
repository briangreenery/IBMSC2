class ResultsController < ApplicationController
  def index
    @players, @names, @leagues, @points, @ranks, @wins, @losses, @matches = Tournament.current.compute_results
  end
end
