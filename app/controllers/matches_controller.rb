class MatchesController < ApplicationController
  # GET /matches
  # GET /matches.xml
  def index
    @matches = Match.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @matches }
    end
  end

  # GET /matches/1
  # GET /matches/1.xml
  def show
    @match = Match.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /matches/new
  # GET /matches/new.xml
  def new
    @players = Player.all( :order => "name" )
    @match = Match.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /matches/1/edit
  def edit
    @match = Match.find(params[:id])
  end

  # POST /matches
  # POST /matches.xml
  def create
    winner = Player.find_by_id( params[:winner][:id] )
    loser = Player.find_by_id( params[:loser][:id] )

    rank_diff = winner.rank - loser.rank

    winner_points = ( rank_diff < 0 ) ? ( 11 - rank_diff.abs ) : ( 10 + rank_diff.abs )
    loser_points = -winner_points

    winner.update_attributes( :points => winner.points + winner_points )
    loser.update_attributes( :points => loser.points + loser_points )

    @match = Match.new( :winner_id => params[:winner][:id],
                        :loser_id => params[:loser][:id],
                        :time => DateTime.now,
                        :winner_points => winner_points,
                        :loser_points => loser_points )

    respond_to do |format|
      if @match.save
        format.html { redirect_to '/' }
        format.xml  { render :xml => @match, :status => :created, :location => @match }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /matches/1
  # PUT /matches/1.xml
  def update
    @match = Match.find(params[:id])

    respond_to do |format|
      if @match.update_attributes(params[:match])
        format.html { redirect_to(@match, :notice => 'Match was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.xml
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to(matches_url) }
      format.xml  { head :ok }
    end
  end
end
