class TournamentsController < ApplicationController
  # GET /tournaments
  def index
    @tournaments = Tournament.order( 'start_date DESC' )

    @current_tournament = Tournament.current

    @participants = {}
    @tournaments.each do |tournament|
      @participants[tournament.id] = Set.new
    end

    Match.all.each do |match|
      @participants[match.tournament_id].add match.winner_id
      @participants[match.tournament_id].add match.loser_id
    end

    @winners = {}
    @tournaments.each do |tournament|
      if tournament != @current_tournament
        @winners[tournament.id] = tournament.standings.first.player
      end
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /tournaments/1
  def show
    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /tournaments/1/edit
  def edit
    @tournament = Tournament.find(params[:id])
  end

  # POST /tournaments
  def create
    @tournament = Tournament.new(params[:tournament])

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to(@tournament, :notice => 'Tournament was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /tournaments/1
  def update
    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        format.html { redirect_to(@tournament, :notice => 'Tournament was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /tournaments/1
  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to(tournaments_url) }
    end
  end
end
