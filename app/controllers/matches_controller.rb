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
    @match = Match.new
    @players = Tournament.current.players.sort { |a,b| a.name.downcase <=> b.name.downcase }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # POST /matches
  # POST /matches.xml
  def create
    @match = Match.new(params[:match])
    @players = Tournament.current.players.sort { |a,b| a.name.downcase <=> b.name.downcase }

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

  # DELETE /matches/1
  # DELETE /matches/1.xml
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to '/' }
      format.xml  { head :ok }
    end
  end
end
