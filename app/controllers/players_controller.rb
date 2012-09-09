class PlayersController < ApplicationController
  # GET /players
  # GET /players.xml
  def index
    @players = Player.all.sort { |a,b| a.name.downcase <=> b.name.downcase }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])

    @matches = Array.new
    Match.order( 'time DESC, id DESC ' ).where( 'winner_id = ? or loser_id = ?', @player.id, @player.id ).each do |match|
      @matches.push( { :opponent => ( match.winner_id == @player.id ? match.loser : match.winner ),
                      :tournament => match.tournament.name,
                      :win => ( match.winner_id == @player.id ),
                      :week => match.week_played,
                      :points => ( match.winner_id == @player.id ? match.winner_points : match.loser_points ) } )
    end

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @player = Player.new

    @inactive_players = []

    Player.all( :order => "lower( name )" ).each do |player|
      @inactive_players.push player if player.points == 0
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @player = Player.new(params[:player])

    @inactive_players = []

    respond_to do |format|
      if @player.save
        Standing.create :tournament => Tournament.current, :player => @player, :points => Tournament.starting_points
        format.html { redirect_to players_path, :notice => 'Player was successfully created.' }
      else
        Player.all( :order => "lower( name )" ).each do |player|
          @inactive_players.push player if player.points == 0
        end
        format.html { render :action => "new" }
      end
    end
  end

  def restore
    @player = Player.find_by_id params[:player]
    Standing.create :tournament => Tournament.current, :player => @player, :points => Tournament.starting_points
    redirect_to '/'
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to(@player, :notice => 'Player was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(players_url) }
    end
  end
end
